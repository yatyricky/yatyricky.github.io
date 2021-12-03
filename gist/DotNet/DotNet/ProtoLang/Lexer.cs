using System;
using System.IO;
using System.Text;

namespace ProtoLang
{
    internal class Lexer
    {
        private StreamReader _reader;
        private readonly StringBuilder _sb;

        public Lexer(string filePath)
        {
            _reader = new StreamReader(filePath);
            _sb = new StringBuilder();
        }

        internal Token Next()
        {
            var token = NextToken();
            Console.WriteLine($"Emit {token}");
            return token;
        }

        internal Token NextToken()
        {
            Token token;
            if (_reader == null)
            {
                return new Token(string.Empty, TokenType.NULL);
            }

            int c;
            while ((c = _reader.Peek()) > 0)
            {
                if (IsEOL(c))
                {
                    return new Token(ReadEOL(), TokenType.EOFL);
                }

                if (IsWhiteSpace(c))
                {
                    return new Token(ReadWhiteSpace(), TokenType.WTSP);
                }

                if (IsSplitter(c))
                {
                    return new Token(ReadSplitter(), TokenType.SPLT);
                }

                if (IsIdentifier(c))
                {
                    return new Token(ReadIdentifier(), TokenType.IDEN);
                }

                if (IsInt(c))
                {
                    return new Token(ReadInt(), TokenType.INTL);
                }

                return new Token(ReadText(), TokenType.TEXT);
            }

            _reader.Close();
            _reader = null;
            return new Token(string.Empty, TokenType.NULL);
        }

        private bool IsWhiteSpace(int c)
        {
            return c == ' ' || c == '\t' || c == '\r';
        }

        private string ReadWhiteSpace()
        {
            _sb.Clear();
            int c;
            do
            {
                _sb.Append(char.ConvertFromUtf32(_reader.Read()));
                c = _reader.Peek();
            } while (c > 0 && IsWhiteSpace(c));

            return _sb.ToString();
        }

        private bool IsSplitter(int c)
        {
            return c == '='
                   || c == ';'
                   || c == ','
                   || c == '{'
                   || c == '}'
                   || c == '<'
                   || c == '>'
                   || c == '/'
                   || c == '*'
                   || c == '\"'
                ;
        }

        private string ReadSplitter()
        {
            return char.ConvertFromUtf32(_reader.Read());
        }

        private bool IsIdentifier(int c)
        {
            return c == '_' || (c >= 'a' && c <= 'z')
                            || (c >= 'A' && c <= 'Z');
        }

        private bool IsIdentifierBody(int c)
        {
            return IsIdentifier(c) || IsInt(c);
        }

        private string ReadIdentifier()
        {
            _sb.Clear();
            int c;
            do
            {
                _sb.Append(char.ConvertFromUtf32(_reader.Read()));
                c = _reader.Peek();
            } while (c > 0 && IsIdentifierBody(c));

            return _sb.ToString();
        }

        private bool IsInt(int c)
        {
            return c >= '0' && c <= '9';
        }

        private string ReadInt()
        {
            _sb.Clear();
            int c;
            do
            {
                _sb.Append(char.ConvertFromUtf32(_reader.Read()));
                c = _reader.Peek();
            } while (c > 0 && IsInt(c));

            return _sb.ToString();
        }

        private bool IsEOL(int c)
        {
            return c == '\n';
        }

        private string ReadEOL()
        {
            return char.ConvertFromUtf32(_reader.Read());
        }

        private string ReadText()
        {
            _sb.Clear();
            int c;
            do
            {
                _sb.Append(char.ConvertFromUtf32(_reader.Read()));
                c = _reader.Peek();
            } while (c > 0 && !IsWhiteSpace(c) && !IsSplitter(c) && !IsEOL(c));

            return _sb.ToString();
        }
    }
}
