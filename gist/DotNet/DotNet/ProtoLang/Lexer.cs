using System;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace ProtoLang
{
    public class Lexer
    {

        private string _filePath;
        private StreamReader _reader;
        private StringBuilder _sb;
        private int[] _buffer;
        private int _bufferIndex;

        public Lexer(string filePath)
        {
            _filePath = filePath;
            _reader = new StreamReader(_filePath);
            _sb = new StringBuilder();
            _buffer = new int[128];
            _bufferIndex = 0;
        }

        public Token Next()
        {
            Token token;
            if (_reader == null)
            {
                token = new Token(string.Empty, TokenType.NULL);
                Console.WriteLine($"Emit token - {token}");
                return token;
            }
            var c = 0;
            while ((c = _reader.Peek()) > 0)
            {
                if (IsEOL(c))
                {
                    token = new Token(ReadEOL(), TokenType.EOFL);
                    Console.WriteLine($"Emit token - {token}");
                    return token;
                }

                if (IsWhiteSpace(c))
                {
                    token = new Token(ReadWhiteSpace(), TokenType.WTSP);
                    Console.WriteLine($"Emit token - {token}");
                    return token;
                }

                if (IsSplitter(c))
                {
                    token = new Token(ReadSplitter(), TokenType.SPLT);
                    Console.WriteLine($"Emit token - {token}");
                    return token;
                }

                if (IsIdentifier(c))
                {
                    token = new Token(ReadIdentifier(), TokenType.IDEN);
                    Console.WriteLine($"Emit token - {token}");
                    return token;
                }

                if (IsInt(c))
                {
                    token = new Token(ReadInt(), TokenType.INTL);
                    Console.WriteLine($"Emit token - {token}");
                    return token;
                }

                token = new Token(ReadText(), TokenType.TEXT);
                Console.WriteLine($"Emit token - {token}");
                return token;
            }

            _reader.Close();
            _reader = null;
            token = new Token(string.Empty, TokenType.NULL);
            Console.WriteLine($"Emit token - {token}");
            return token;
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

        private bool IsLineWhiteSpace(int c)
        {
            return c == ' ' || c == '\t' || c == '\r';
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
