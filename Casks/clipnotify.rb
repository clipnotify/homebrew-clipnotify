cask "clipnotify" do
  version "26.02"
  sha256 "ffa47c4222cd649875d157ca2854cb2a5070e9870a9d68d4ae49aa08ad10cc77"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-native-v#{version}.dmg"
  name "ClipNotify"
  desc "Bridge between remote Claude Code sessions and your local Mac"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
