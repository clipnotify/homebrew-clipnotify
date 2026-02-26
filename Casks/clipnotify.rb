cask "clipnotify" do
  version "26.06"
  sha256 "bae6b0f1fa690b31937a4b4d1c78bfbe2e59bad981341ced0b90178f960eb231"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-native-v#{version}.dmg"
  name "ClipNotify"
  desc "Bridge between remote Claude Code sessions and your local Mac"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
