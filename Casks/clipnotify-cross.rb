cask "clipnotify-cross" do
  version "26.02"
  sha256 "c498cef94c8678f549859415600f139e0ae2714b6f56620004e88e980f6a7a6b"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-v#{version}.dmg"
  name "ClipNotify (Cross-platform)"
  desc "Bridge between remote Claude Code sessions and your local Mac (Go/Wails)"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
