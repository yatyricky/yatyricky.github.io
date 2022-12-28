

            // var dummyAsset = AssetDatabase.LoadAssetAtPath<Monster>("Assets/Editor/GameConfig_bl/Monsters/1.asset");
            // foreach (var file in Directory.GetFiles("Assets/Editor/GameConfig_bl/Monsters"))
            // {
            //     if (!file.EndsWith(".asset"))
            //     {
            //         continue;
            //     }
            //
            //     string configName = null;
            //     string configType = null;
            //     using (var sr = new StreamReader(file))
            //     {
            //         string line;
            //         while ((line = sr.ReadLine()) != null)
            //         {
            //             if (configName == null && line.StartsWith("  Name:"))
            //             {
            //                 configName = Regex.Replace(line.Substring(7).Trim('"'), @"\\u([0-9a-fA-F]{4})", match => char.ConvertFromUtf32(int.Parse(match.Groups[1].Value, System.Globalization.NumberStyles.HexNumber)));
            //             }
            //
            //             if (configType == null && line.StartsWith("  Type:"))
            //             {
            //                 configType = line.Substring(7).Trim();
            //             }
            //
            //             if (configName != null && configType != null)
            //             {
            //                 break;
            //             }
            //         }
            //     }
            //
            //     var type = (Monster.TMonsterType)int.Parse(configType ?? throw new InvalidOperationException());
            //
            //     tree.Add($"{type}/[{Path.GetFileNameWithoutExtension(file)}]{configName}", dummyAsset);
            // }