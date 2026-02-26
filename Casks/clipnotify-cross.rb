cask "clipnotify-cross" do
  version "26.06"
  sha256 "845635198664765fdcdd1ebd93dd37fa636e4d5228f6c3847b34231cdbc5e691"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-v#{version}.dmg"
  name "ClipNotify (Cross-platform)"
  desc "Bridge between remote Claude Code sessions and your local Mac (Go/Wails)"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
