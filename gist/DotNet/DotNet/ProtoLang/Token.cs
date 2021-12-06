namespace ProtoLang
{
    internal enum TokenType
    {
        NULL,
        IDEN, // dataEntry
        INTL, // 15
        STRL, // "lorem"
        WTSP,
        TEXT,
        SPLT,
        EOFL,
    }

    internal class Token
    {
        public readonly TokenType Type;
        public readonly string Content;

        internal Token(string content, TokenType type)
        {
            Content = content;
            Type = type;
        }

        public override string ToString()
        {
            return $"{Type} {Content.Replace("\n", "\\n").Replace("\r", "\\r")}";
        }
    }
}
