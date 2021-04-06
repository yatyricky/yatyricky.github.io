using System;
using System.Buffers.Binary;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace DotNet
{
    class NPPATest
    {
        public static void NPPASign(string ai, string name, string idNum, string appId, string bizId, string timestamp, string secretKey, out string retSign, out string retBody)
        {
            // 1 准备业务参数与密钥
            // 1.1 业务参数文本
            var content = $"{{\"ai\":\"{ai}\",\"name\":\"{name}\",\"idNum\":\"{idNum}\"}}";
            // 1.2 密钥
            // 1.3 处理密钥（将16进制字符串密钥转换为byte数组）
            var keyBytes = HexStringToByte(secretKey);

            Console.WriteLine($"keyBytes:{BitConverter.ToString(keyBytes)}");
            Console.WriteLine($"content:{content}");

            // 2 业务参数加密（AES-128/GCM + BASE64算法加密）计算
            var encryptStr = AesGcmEncrypt(content, keyBytes);
            Console.WriteLine($"业务参数加密结果：{encryptStr}");
            //        // 解密
            //        String decryptStr = aesGcmDecrypt(encryptStr, keyBytes);
            //        System.out.println("业务参数解密结果：" + decryptStr);

            // 3 签名
            /*
             * 签名规则：1 将除去sign的系统参数和除去请求体外的业务参数，根据参数的key进行字典排序，并按照Key-Value的格式拼接成一个字符串。将请求体中的参数拼接在字符串最后。
             *          2 将secretKey拼接在步骤1获得字符串最前面，得到待加密字符串。
             *          3 使用SHA256算法对待加密字符串进行计算，得到数据签名。
             *          4 将得到的数据签名赋值给系统参数sign。
             */
            // 3.1 拼接待签名字符串（下方示例代码中相应字符串均为写死，仅用于参考拼接流程，具体请参照实际接口参数）
            var sb = new StringBuilder();
            // 3.1.1 拼接密钥
            sb.Append(secretKey);
            // 3.1.2 拼接除去sign的系统参数和除去请求体外的业务参数（含请求URL中的参数，例如get请求。注意需要字典排序）
            sb.Append($"ai-{ai}");
            sb.Append($"appId-{appId}");
            sb.Append($"bizId-{bizId}");
            sb.Append($"idNum-{idNum}");
            sb.Append($"name-{name}");
            sb.Append($"timestamps-{timestamp}");
            // 3.1.3 拼接请求体（保持json字符串格式，data对应的值应为上方加密算法计算出的encryptStr加密字符串）
            var body = $"{{\"data\":\"{encryptStr}\"}}";
            sb.Append(body);

            var toBeSignStr = sb.ToString();
            Console.WriteLine($"待签名字符串：{toBeSignStr}");

            // 3.1 签名计算（SHA256）
            var sign = Sign(toBeSignStr);
            Console.WriteLine($"签名结果：{sign}");
            retSign = sign;
            retBody = body;
        }

        /**
         * <p>@title hexStringToByte</p>
         * <p>@description 十六进制string转二进制byte[]</p>
         *
         * @param str 十六进制字符串
         * @return byte[]
         */
        private static byte[] HexStringToByte(string hex)
        {
            var numberChars = hex.Length;
            var bytes = new byte[numberChars / 2];
            for (var i = 0; i < numberChars; i += 2)
                bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
            return bytes;
        }

        /**
         * <p>@title aesGcmEncrypt</p>
         * <p>@description Aes-Gcm加密</p>
         *
         * @param content 待加密文本
         * @param key     密钥
         * @return java.lang.String
         */
        private static string AesGcmEncrypt(string content, byte[] key)
        {
            // Get bytes of plaintext string
            byte[] plainBytes = Encoding.UTF8.GetBytes(content);

            // Get parameter sizes
            int nonceSize = 12; // AesGcm.NonceByteSizes.MaxSize;
            int tagSize = 128; // AesGcm.TagByteSizes.MaxSize;
            int cipherSize = plainBytes.Length;

            // We write everything into one big array for easier encoding
            int encryptedDataLength = 4 + nonceSize + 4 + tagSize + cipherSize;
            Span<byte> encryptedData = encryptedDataLength < 1024
                                     ? stackalloc byte[encryptedDataLength]
                                     : new byte[encryptedDataLength].AsSpan();

            // Copy parameters
            BinaryPrimitives.WriteInt32LittleEndian(encryptedData.Slice(0, 4), nonceSize);
            BinaryPrimitives.WriteInt32LittleEndian(encryptedData.Slice(4 + nonceSize, 4), tagSize);
            var nonce = encryptedData.Slice(4, nonceSize);
            var tag = encryptedData.Slice(4 + nonceSize + 4, tagSize);
            var cipherBytes = encryptedData.Slice(4 + nonceSize + 4 + tagSize, cipherSize);

            // Generate secure nonce
            RandomNumberGenerator.Fill(nonce);

            // Encrypt
            using var aes = new AesGcm(key);
            aes.Encrypt(nonce, plainBytes.AsSpan(), cipherBytes, tag);

            // Encode for transmission
            return Convert.ToBase64String(encryptedData);
        }

        protected static byte[] EncryptStringToBytes(string plainText, byte[] Key, byte[] IV)
        {
            // Check arguments. 
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            if (IV == null || IV.Length <= 0)
                throw new ArgumentNullException("Key");
            byte[] encrypted;
            // Create an RijndaelManaged object 
            // with the specified key and IV. 
            using (RijndaelManaged rijAlg = new RijndaelManaged())
            {
                rijAlg.Key = Key;
                rijAlg.IV = IV;

                // Create a decrytor to perform the stream transform.
                ICryptoTransform encryptor = rijAlg.CreateEncryptor(rijAlg.Key, rijAlg.IV);

                // Create the streams used for encryption. 
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {

                            //Write all data to the stream.
                            swEncrypt.Write(plainText);
                        }
                        encrypted = msEncrypt.ToArray();
                    }
                }
            }
            // Return the encrypted bytes from the memory stream. 
            return encrypted;

        }

        /**
         * <p>@title sign</p>
         * <p>@description 签名</p>
         *
         * @param toBeSignStr 待签名字符串
         * @return java.lang.String
         */
        private static string Sign(string toBeSignStr)
        {
            var bytes = Encoding.UTF8.GetBytes(toBeSignStr);
            var sha256 = new SHA256Managed();
            var hash = sha256.ComputeHash(bytes);
            return hash.Aggregate(string.Empty, (current, x) => current + $"{x:x2}");
        }

        internal static void Start()
        {
            string appId = "cf370ddcf3ee4ac0bcc43b429b5ba321";
            string bizId = "1101999999";
            string secretKey = "2836e95fcd10e04b0069bb1ee659955b";
            string timestamps = "";
            string sign = "";

            string ai = "test-accountId";
            string pName = "incase";
            string idNum = "371321199012310912";

            string body = "";
            string jsonBody = "";

            NPPASign(ai, pName, idNum, appId, bizId, timestamps, secretKey, out var retSign, out var retBody);
            sign = retSign;
            body = retBody;
            jsonBody = $@"{{""ai"":""{ai}"",""name"":""{pName}"",""idNum"":""{idNum}""}}";
        }
    }
}
