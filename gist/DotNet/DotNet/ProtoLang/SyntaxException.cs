using System;

namespace ProtoLang
{
    internal class SyntaxException : Exception
    {
        public override string Message { get; }

        public SyntaxException()
        {
        }

        public SyntaxException(string message)
        {
            Message = message;
        }
    }
}
