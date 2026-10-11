using System;
using System.Diagnostics;
using System.IO;
using System.Net.Sockets;
using System.Threading;

namespace XerVipStore
{
    static class AdminApp
    {
        // Live 24/7 Render cloud URL (falls back to localhost:3000)
        private const string CLOUD_URL = "https://xers-vip-store.onrender.com/admin.html";
        private const string LOCAL_URL = "http://localhost:3000/admin.html";
        private const string APP_TITLE = "XER'S VIP ADMIN - Management Console";

        [STAThread]
        static void Main(string[] args)
        {
            string targetUrl = CLOUD_URL;
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;

            // If local server.js exists nearby, check if we need local fallback
            string serverJs = Path.Combine(baseDir, "server.js");
            if (!File.Exists(serverJs))
            {
                serverJs = Path.Combine(baseDir, "..", "server.js");
                if (File.Exists(serverJs))
                {
                    baseDir = Path.GetFullPath(Path.Combine(baseDir, ".."));
                }
            }

            // If args specified --local, force localhost
            bool forceLocal = false;
            foreach (string a in args)
            {
                if (a.ToLower() == "--local") forceLocal = true;
            }

            if (forceLocal)
            {
                EnsureLocalServer(baseDir);
                targetUrl = LOCAL_URL;
            }
            else
            {
                // Default to cloud URL (24/7 online)
                targetUrl = CLOUD_URL;
            }

            LaunchStandaloneWindow(targetUrl, APP_TITLE);
        }

        static bool IsPortOpen(string host, int port)
        {
            try
            {
                using (var client = new TcpClient())
                {
                    var result = client.BeginConnect(host, port, null, null);
                    bool success = result.AsyncWaitHandle.WaitOne(600);
                    if (success)
                    {
                        client.EndConnect(result);
                        return true;
                    }
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        static void EnsureLocalServer(string dir)
        {
            if (IsPortOpen("127.0.0.1", 3000)) return;

            string serverJs = Path.Combine(dir, "server.js");
            if (File.Exists(serverJs))
            {
                try
                {
                    var psi = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = "/c node \"" + serverJs + "\"",
                        WorkingDirectory = dir,
                        WindowStyle = ProcessWindowStyle.Hidden,
                        CreateNoWindow = true,
                        UseShellExecute = true
                    };
                    Process.Start(psi);

                    for (int i = 0; i < 20; i++)
                    {
                        Thread.Sleep(300);
                        if (IsPortOpen("127.0.0.1", 3000)) break;
                    }
                }
                catch { }
            }
        }

        static void LaunchStandaloneWindow(string url, string title)
        {
            string programFiles = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            string programFilesX86 = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86);
            string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

            string[] candidates = new string[]
            {
                Path.Combine(programFiles, "Microsoft", "Edge", "Application", "msedge.exe"),
                Path.Combine(programFilesX86, "Microsoft", "Edge", "Application", "msedge.exe"),
                Path.Combine(localAppData, "Microsoft", "Edge", "Application", "msedge.exe"),
                Path.Combine(programFiles, "Google", "Chrome", "Application", "chrome.exe"),
                Path.Combine(programFilesX86, "Google", "Chrome", "Application", "chrome.exe"),
                Path.Combine(localAppData, "Google", "Chrome", "Application", "chrome.exe")
            };

            foreach (string exePath in candidates)
            {
                if (File.Exists(exePath))
                {
                    try
                    {
                        var psi = new ProcessStartInfo
                        {
                            FileName = exePath,
                            Arguments = "--app=\"" + url + "\" --window-size=1366,860 --name=\"" + title + "\"",
                            UseShellExecute = false
                        };
                        Process.Start(psi);
                        return;
                    }
                    catch { }
                }
            }

            // Fallback: Default Browser
            try
            {
                Process.Start(new ProcessStartInfo(url) { UseShellExecute = true });
            }
            catch { }
        }
    }
}
