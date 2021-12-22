using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ProtoLang
{
    public class Node
    {
        internal string Name { get; private set; }
        internal string Content { get; private set; }
        internal List<Node> Children { get; private set; }

        internal Node(string name, params Node[] children)
        {
            Name = name;
            Children = new List<Node>();
            AddChild(children);
        }

        internal Node(string name, string content)
        {
            Name = name;
            Content = content;
            Children = new List<Node>();
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
                    Children.Add(child);
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
            sb.Append(curr.Name);
            sb.Append(']');
            if (!string.IsNullOrEmpty(curr.Content))
            {
                sb.Append(" - ");
                sb.Append(curr.Content);
            }

            sb.Append('\n');
            foreach (var child in curr.Children)
            {
                ToText(sb, child, level + 4);
            }
        }

        public List<Node> FindAll(string name)
        {
            return (from node in Children where node.Name == name select node).ToList();
        }

        public Node Find(string name)
        {
            return FindAll(name).FirstOrDefault();
        }

        public Node ReplaceWith(Node newNode)
        {
            Name = newNode.Name;
            Content = newNode.Content;
            Children = newNode.Children;
            return newNode;
        }

        public override string ToString()
        {
            var sb = new StringBuilder();
            ToText(sb, this, 0);
            return sb.ToString();
        }
    }
}
