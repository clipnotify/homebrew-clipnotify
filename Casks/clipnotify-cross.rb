cask "clipnotify-cross" do
  version "26.02"
  sha256 "b8a358a18dda2782e635f91c5d9fb2d880a1e2efc4364a3f510e707659bf6e0d"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-v#{version}.dmg"
  name "ClipNotify (Cross-platform)"
  desc "Bridge between remote Claude Code sessions and your local Mac (Go/Wails)"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
