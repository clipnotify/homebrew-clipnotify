cask "clipnotify" do
  version "26.01"
  sha256 "05790a440d0c2e798c9b843514c44b4408793fec4bc577ce0db429e8d29eea47"

  url "https://gitlab.com/clipnotify/clipnotify/-/releases/v#{version}/downloads/ClipNotify-native-v#{version}.dmg"
  name "ClipNotify"
  desc "Bridge between remote Claude Code sessions and your local Mac"
  homepage "https://gitlab.com/clipnotify/clipnotify"

  depends_on macos: ">= :ventura"

  app "ClipNotify.app"

  zap trash: "~/.config/clipnotify"
end
