using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace ProtoLang
{
    public class Parser
    {
        public class SyntaxException : Exception
        {
            public SyntaxException():base(){}
            public SyntaxException(string message) : base() { }
        }
        
        public class Node
        {
            private string _name;
            private bool _beLeaf;
            private string _content;
            private List<Node> _children;
            
            public Node(string name, params Node[] children)
            {
                _name = name;
                _beLeaf = false;
                _children = new List<Node>();
                AddChild(children);
            }

            public Node(string name, string content)
            {
                _name = name;
                _beLeaf = true;
                _content = content;
                _children = new List<Node>();
            }

            public void AddChild(params Node[] children)
            {
                if (children == null || children.Length == 0)
                {
                    return;
                }
                foreach (var child in children)
                {
                    if (child != null)
                    {
                        _children.Add(child);
                    }
                }
            }

            private static void ToText(StringBuilder sb, Node curr, int level)
            {
                for (int i = 0; i < level; i++)
                {
                    sb.Append(' ');
                }
                sb.Append('[');
                sb.Append(curr._name);
                sb.Append(']');
                if (!string.IsNullOrEmpty(curr._content))
                {
                    sb.Append(" - ");
                    sb.Append(curr._content);
                }
                sb.Append('\n');
                foreach (var child in curr._children)
                {
                    ToText(sb, child, level + 4);
                }
            }

            public override string ToString()
            {
                var sb = new StringBuilder();
                ToText(sb, this, 0);
                return sb.ToString();
            }
        }
        
        private Lexer _lexer;
        private Stack<Token> _stack;

        public Parser(string filePath)
        {
            _lexer = new Lexer(filePath);
            _stack = new Stack<Token>();
        }

        private Node ParseProto()
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
            if (token .Type != TokenType.SPLT || token.Content != ";")
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
                    return new Node("String", "\"" + sb.ToString() + "\"");
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
                if (comment == null && message == null && @enum == null)
                {
                    break;
                }
                node.AddChild(comment, message, @enum);
            }
            return node;
        }

        private Node ParseComment()
        {
            var line = ParseLineComment();
            if (line != null)
            {
                return line;
            }
            var block = NodeParseBlockComment();
            if (block != null)
            {
                return block;
            }
            return null;
        }

        private Node ParseLineComment()
        {
            var token = NextNonWhiteSpaceToken();
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
                    return new Node("LineComment", "//" + sb.ToString());
                }
                sb.Append(token.Content);
            }
        }

        private Node NodeParseBlockComment()
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
                        return new Node("BlockComment", "/*" + sb.ToString() + "*/");
                    }
                    else
                    {
                        sb.Append(_stack.Pop().Content);
                    }
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
                body.AddChild(field);
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
                body.AddChild(field);
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
            var field = ParseReservedField();
            if (field != null)
            {
                return field;
            }
            field = ParseActiveField();
            if (field != null)
            {
                return field;
            }
            return null;
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
            var comment = ParseLineComment();
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
                var valueType= ParseFieldTypeSimple();
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
            var token = NextNonWhiteSpaceToken();
            if (token.Type != TokenType.IDEN)
            {
                return null;
            }
            _stack.Pop();
            return new Node("SimpleType", token.Content);
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
            return new Node("ReservedField", new Node("FieldNumber", fieldNumber), ParseLineComment());
        }

        private Token NextNonWhiteSpaceToken(bool excludeEOL = false)
        {
            Console.WriteLine($"Current Stack = [{string.Join(",", _stack)}]");
            if (_stack.Count == 0)
            {
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
            else
            {
                return _stack.Peek();
            }
        }

        // test
        public static void Tokenize()
        {
            foreach (var file in Directory.GetFiles(@"C:\Users\yatyr\workspace\barrett-client\protos"))
            {
                if (file.EndsWith(".proto"))
                {
                    var baseName = Path.GetFileNameWithoutExtension(file);
                    var parser = new Parser(file);
                    var node = parser.ParseProto();
                    File.WriteAllText(@"C:\Users\yatyr\workspace\barrett-client\protos\" + baseName + "-ast.txt", node.ToString());
                }
            }
        }
    }
}
