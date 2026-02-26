cask "clipnotify" do
  version "26.02"
  sha256 "93e826b96c03be9d9f9e37bca2db8c168ea708480d0e2340323e9d9527fce38a"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-native-v#{version}.dmg"
  name "ClipNotify"
  desc "Bridge between remote Claude Code sessions and your local Mac"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
