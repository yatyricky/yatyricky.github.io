using System.Collections.Generic;
using System.Text;

namespace ProtoLang
{
    public class Parser
    {
        private readonly Lexer _lexer;
        private readonly Stack<Token> _stack;

        public Parser(string filePath)
        {
            _lexer = new Lexer(filePath);
            _stack = new Stack<Token>();
        }

        public Node ParseProto()
        {
            var node = new Node("Proto3");
            var headers = ParseHeaders();
            var messages = ParseMessages();
            node.AddChild(headers, messages);
            return node;
        }

        private Node ParseHeaders()
        {
            var node = new Node("Headers");
            while (true)
            {
                var syntax = ParseHeaderSyntax();
                var import = ParseHeaderImport();
                var option = ParseHeaderOption();
                if (syntax == null && import == null && option == null)
                {
                    break;
                }

                node.AddChild(syntax, import, option);
            }

            return node;
        }

        private Node ParseHeaderSyntax()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "syntax")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "=")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var stringNode = ParseString();
            if (stringNode == null)
            {
                throw new SyntaxException();
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            return new Node("HeaderSyntax", stringNode);
        }

        private Node ParseHeaderOption()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "option")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException();
            }

            var optName = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "=")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var stringNode = ParseString();
            if (stringNode == null)
            {
                throw new SyntaxException();
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            return new Node("HeaderOption", new Node("OptionName", optName), stringNode);
        }

        private Node ParseHeaderImport()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "import")
            {
                return null;
            }

            _stack.Pop();
            var stringNode = ParseString();
            if (stringNode == null)
            {
                throw new SyntaxException();
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            return new Node("HeaderImport", stringNode);
        }

        private Node ParseString()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "\"")
            {
                return null;
            }

            _stack.Pop();
            var sb = new StringBuilder();
            while (true)
            {
                token = _lexer.Next();
                if (token.Type == TokenType.NULL)
                {
                    throw new SyntaxException();
                }

                if (token.Type == TokenType.SPLT && token.Content == "\"")
                {
                    return new Node("String", $"\"{sb}\"");
                }

                sb.Append(token.Content);
            }
        }

        private Node ParseMessages()
        {
            var node = new Node("Messages");
            while (true)
            {
                var comment = ParseComment();
                var message = ParseMessage();
                var @enum = ParseEnum();
                var service = ParseService();
                if (comment == null && message == null && @enum == null && service == null)
                {
                    break;
                }

                node.AddChild(comment, message, @enum, service);
            }

            return node;
        }

        private Node ParseComment()
        {
            return ParseLineComment() ?? ParseBlockComment();
        }

        private Node ParseLineComment(bool dontWrap = false)
        {
            var token = NextNonWhiteSpaceToken(dontWrap);
            if (token.Type != TokenType.SPLT || token.Content != "/")
            {
                return null;
            }

            var firstSlash = _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "/")
            {
                _stack.Push(firstSlash);
                return null;
            }

            _stack.Pop();
            var sb = new StringBuilder();
            while (true)
            {
                token = _lexer.Next();
                if (token.Type == TokenType.NULL || token.Type == TokenType.EOFL)
                {
                    return new Node("LineComment", $"//{sb}");
                }

                sb.Append(token.Content);
            }
        }

        private Node ParseBlockComment()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "/")
            {
                return null;
            }

            var firstSlash = _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "*")
            {
                _stack.Push(firstSlash);
                return null;
            }

            _stack.Pop();
            var sb = new StringBuilder();
            while (true)
            {
                token = _lexer.Next();
                if (token.Type == TokenType.NULL)
                {
                    throw new SyntaxException();
                }

                if (token.Type == TokenType.SPLT && token.Content == "*")
                {
                    _stack.Push(token);
                    token = _lexer.Next();
                    if (token.Type == TokenType.SPLT && token.Content == "/")
                    {
                        _stack.Pop();
                        return new Node("BlockComment", $"/*{sb}*/");
                    }

                    sb.Append(_stack.Pop().Content);
                }

                sb.Append(token.Content);
            }
        }

        private Node ParseMessage()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "message")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException();
            }

            var messageName = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "{")
            {
                throw new SyntaxException(token.Content);
            }

            _stack.Pop();
            var body = new Node("MessageBody");
            var node = new Node("Message", new Node("MessageName", messageName), body);
            while (true)
            {
                token = NextNonWhiteSpaceToken();
                if (token.Type == TokenType.SPLT && token.Content == "}")
                {
                    _stack.Pop();
                    return node;
                }

                var field = ParseAnyField();
                var comment = ParseLineComment();
                if (field == null && comment == null)
                {
                    throw new SyntaxException();
                }

                body.AddChild(field, comment);
            }
        }

        private Node ParseEnum()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "enum")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var enumName = token.Content;
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "{")
            {
                throw new SyntaxException(token.Content);
            }

            _stack.Pop();

            var body = new Node("EnumBody");
            var node = new Node("Enum", new Node("EnumName", enumName), body);
            while (true)
            {
                token = NextNonWhiteSpaceToken();
                if (token.Type == TokenType.SPLT && token.Content == "}")
                {
                    _stack.Pop();
                    return node;
                }

                var field = ParseEnumField();
                var comment = ParseLineComment();
                if (field == null && comment == null)
                {
                    throw new SyntaxException();
                }

                body.AddChild(field, comment);
            }
        }

        private Node ParseEnumField()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                return null;
            }

            _stack.Pop();
            var fieldName = token.Content;
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "=")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.INTL)
            {
                throw new SyntaxException();
            }

            var fieldNumber = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            return new Node("EnumField", new Node("EnumName", fieldName), new Node("EnumValue", fieldNumber), ParseLineComment());
        }

        private Node ParseAnyField()
        {
            return ParseMessage() ?? ParseReservedField() ?? ParseActiveField();
        }

        private Node ParseActiveField()
        {
            var fieldType = ParseFieldType();
            if (fieldType == null)
            {
                return null;
            }

            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var fieldName = token.Content;
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "=")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.INTL)
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var fieldNumber = token.Content;
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var comment = ParseLineComment(true);
            ConsumeEOL();
            return new Node("ActiveField", fieldType, new Node("FieldName", fieldName), new Node("FieldNumber", fieldNumber), comment);
        }

        private Node ParseFieldType()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                return null;
            }

            if (token.Content == "repeated")
            {
                _stack.Pop();
                return new Node("RepeatedType", ParseFieldTypeSimple());
            }

            if (token.Content == "map")
            {
                _stack.Pop();
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.SPLT || token.Content != "<")
                {
                    throw new SyntaxException();
                }

                _stack.Pop();
                var keyType = ParseFieldTypeSimple();
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.SPLT || token.Content != ",")
                {
                    throw new SyntaxException();
                }

                _stack.Pop();
                var valueType = ParseFieldTypeSimple();
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.SPLT || token.Content != ">")
                {
                    throw new SyntaxException();
                }

                _stack.Pop();
                return new Node("MapType", keyType, valueType);
            }

            return ParseFieldTypeSimple();
        }

        private Node ParseFieldTypeSimple()
        {
            var ns = ParseNamespace();
            if (ns == null)
            {
                return null;
            }

            return new Node("SimpleType", ns);
        }

        private Node ParseReservedField()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "reserved")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.INTL)
            {
                throw new SyntaxException();
            }

            var fieldNumber = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException();
            }

            _stack.Pop();
            var comment = ParseLineComment(true);
            ConsumeEOL();
            return new Node("ReservedField", new Node("FieldNumber", fieldNumber), comment);
        }

        private Node ParseService()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "service")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException("service missing: iden");
            }

            var serviceName = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "{")
            {
                throw new SyntaxException("service iden missing: {");
            }

            _stack.Pop();
            var service = new Node("Service", new Node("ServiceName", serviceName));
            var body = new Node("ServiceBody");
            service.AddChild(body);
            while (true)
            {
                token = NextNonWhiteSpaceToken();
                if (token.Type == TokenType.SPLT && token.Content == "}")
                {
                    _stack.Pop();
                    break;
                }

                var rpc = ParseRPC();
                var comment = ParseLineComment();
                if (rpc == null && comment == null)
                {
                    throw new SyntaxException("service body has neither rpc nor comment");
                }

                body.AddChild(rpc, comment);
            }

            return service;
        }

        private Node ParseRPC()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "rpc")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException("rpc missing: iden");
            }

            var rpcName = token.Content;
            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "(")
            {
                throw new SyntaxException("rpc missing: (");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException("rpc ( missing: iden");
            }

            var takes = token.Content;

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ")")
            {
                throw new SyntaxException("rpc(iden missing: )");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "returns")
            {
                throw new SyntaxException("rpc (iden) missing: returns");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "(")
            {
                throw new SyntaxException("rpc iden(takes) returns missing: (");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                throw new SyntaxException("rpc iden(takes) returns( missing: iden");
            }

            var returns = token.Content;

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ")")
            {
                throw new SyntaxException("rpc iden(takes) returns(returns missing: )");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || (token.Content != ";" && token.Content != "{"))
            {
                throw new SyntaxException("rpc iden(takes) returns(returns) missing: ;|{");
            }

            _stack.Pop();
            var rpc = new Node("RPC",
                new Node("RPCSignature",
                    new Node("RPCName", rpcName),
                    new Node("RPCTakes", takes),
                    new Node("RPCReturns", returns)
                )
            );
            if (token.Content == "{")
            {
                var body = new Node("RPCBody");
                while (true)
                {
                    var option = ParseRPCOption();
                    if (option == null)
                    {
                        token = NextNonWhiteSpaceToken();
                        if (token.Type != TokenType.SPLT || token.Content != "}")
                        {
                            throw new SyntaxException("rpc body must end with }");
                        }

                        _stack.Pop();
                        break;
                    }
                    else
                    {
                        body.AddChild(option);
                    }
                }

                rpc.AddChild(body);
            }

            return rpc;
        }

        private Node ParseRPCOption()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN || token.Content != "option")
            {
                return null;
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "(")
            {
                throw new SyntaxException("option missing: (");
            }

            _stack.Pop();
            var ns = ParseNamespace();
            if (ns == null)
            {
                throw new SyntaxException("option( missing: namespace");
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ")")
            {
                throw new SyntaxException("option(namespace missing: )");
            }

            _stack.Pop();
            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "=")
            {
                throw new SyntaxException("option(namespace) missing: =");
            }

            _stack.Pop();
            var obj = ParseRPCOptionDefine();
            if (obj == null)
            {
                throw new SyntaxException("option(namespace)= missing: {");
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != ";")
            {
                throw new SyntaxException("option(namespace) ={} missing: ;");
            }

            _stack.Pop();
            return new Node("RPCOption", ns, obj);
        }

        private Node ParseNamespace()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                return null;
            }

            var ns = new Node("Namespace");
            ns.AddChild(new Node("String", token.Content));

            _stack.Pop();
            while (true)
            {
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.SPLT || token.Content != ".")
                {
                    break;
                }

                _stack.Pop();
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.IDEN)
                {
                    throw new SyntaxException("namespace. missing: iden");
                }

                ns.AddChild(new Node("String", token.Content));
                _stack.Pop();
            }

            return ns;
        }

        private Node ParseRPCOptionDefine()
        {
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "{")
            {
                return null;
            }

            _stack.Pop();
            var def = new Node("RPCOptionDefine");
            while (true)
            {
                var ensureNext = false;
                token = NextNonWhiteSpaceToken();
                if (token.Type == TokenType.SPLT && token.Content == ",")
                {
                    if (def.Children.Count == 0)
                    {
                        throw new SyntaxException("kvp must not start with ,");
                    }

                    ensureNext = true;
                    _stack.Pop();
                    token = NextNonWhiteSpaceToken();
                }

                if (token.Type != TokenType.IDEN)
                {
                    if (ensureNext)
                    {
                        throw new SyntaxException("{kv, missing: iden");
                    }

                    break;
                }

                var key = token.Content;

                _stack.Pop();
                token = NextNonWhiteSpaceToken();
                if (token.Type != TokenType.SPLT || token.Content != ":")
                {
                    throw new SyntaxException("{key missing: :");
                }

                _stack.Pop();
                var value = ParseString();
                if (value == null)
                {
                    throw new SyntaxException("{key: missing: \"\"");
                }

                def.AddChild(new Node("KVPair", new Node("Key", key), new Node("Value", value.Content)));
            }

            token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.SPLT || token.Content != "}")
            {
                throw new SyntaxException("{kv missing: }");
            }

            _stack.Pop();

            return def;
        }

        private void ConsumeEOL()
        {
            while (_stack.Count > 0)
            {
                var c = _stack.Peek();
                if (c.Type == TokenType.EOFL)
                {
                    _stack.Pop();
                }
            }
        }

        private Token NextNonWhiteSpaceToken(bool excludeEOL = false)
        {
            if (_stack.Count != 0)
                return _stack.Peek();

            do
            {
                var token = _lexer.Next();
                if (token.Type == TokenType.NULL)
                {
                    return token;
                }

                if (excludeEOL)
                {
                    if (token.Type != TokenType.WTSP)
                    {
                        _stack.Push(token);
                        return token;
                    }
                }
                else
                {
                    if (token.Type != TokenType.WTSP && token.Type != TokenType.EOFL)
                    {
                        _stack.Push(token);
                        return token;
                    }
                }
            } while (true);
        }
    }
}
