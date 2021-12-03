namespace ProtoLang
{
    public enum TokenType
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

    public class Token
    {
        public TokenType Type;
        public string Content;

        public Token(string content, TokenType type)
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
