using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ProtoLang
{
    internal class Node
    {
        private readonly string _name;
        private readonly string _content;
        private readonly List<Node> _children;

        internal string Name => _name;
        internal string Content => _content;
        internal List<Node> Children => _children;

        internal Node(string name, params Node[] children)
        {
            _name = name;
            _children = new List<Node>();
            AddChild(children);
        }

        internal Node(string name, string content)
        {
            _name = name;
            _content = content;
            _children = new List<Node>();
        }

        internal void AddChild(params Node[] children)
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

        internal List<Node> FindAll(string name)
        {
            return (from node in _children where node._name == name select node).ToList();
        }

        internal Node Find(string name)
        {
            return FindAll(name).FirstOrDefault();
        }

        public override string ToString()
        {
            var sb = new StringBuilder();
            ToText(sb, this, 0);
            return sb.ToString();
        }
    }
}
