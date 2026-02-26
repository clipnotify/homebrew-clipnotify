cask "clipnotify-cross" do
  version "26.01"
  sha256 "4807ddece0ed8080a9da280d4b13051353ad5f5436cfc9e132bc3623f29c5385"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-v#{version}.dmg"
  name "ClipNotify (Cross-platform)"
  desc "Bridge between remote Claude Code sessions and your local Mac (Go/Wails)"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
