using System;

namespace ProtoLang
{
    internal class SyntaxException : Exception
    {
        public override string Message { get; }

        internal SyntaxException()
        {
        }

        internal SyntaxException(string message)
        {
            Message = message;
        }
    }
}
