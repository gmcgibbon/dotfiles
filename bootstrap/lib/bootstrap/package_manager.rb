# frozen_string_literal: true

module Bootstrap
  class PackageManager
    class << self
      def inherited(subclass)
        super
        subclass.singleton_class.alias_method(subclass.command_name, :command)
      end

      def command_name
        @command_name ||= name.dup.tap do |class_name|
          class_name.delete_prefix!("Bootstrap::")
          class_name.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          class_name.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
          class_name.tr!("-", "_")
          class_name.gsub!("::", "-")
          class_name.downcase!
        end
      end

      def install(package_name)
        command("install", package_name)
      end

      def source(_location)
        raise(NotImplementedError)
      end

      def sudo?
        false
      end

      private

      def run(*args)
        args.prepend("sudo") if sudo?
        system(*args)
      end

      def command(*)
        run(command_name, *)
      end
    end
  end

  class Brew < PackageManager
    CASKS_FILE = File.expand_path("package/casks.yml", __dir__)
    CASKS_URL = "https://formulae.brew.sh/api/cask.json"

    private_constant(:CASKS_FILE, :CASKS_URL)

    class << self
      def install(package_name)
        if cask?(package_name)
          brew("install", "--cask", package_name)
        else
          super
        end
      end

      def source(location)
        brew("tap", location)
      end

      private

      def cask_packages
        @cask_packages ||= begin
          require("yaml")
          if File.exist?(CASKS_FILE)
            YAML.safe_load_file(CASKS_FILE)
          else
            download_casks.tap { |data| File.write(CASKS_FILE, YAML.dump(data)) }
          end
        end
      end

      def download_casks
        require("net/http")
        require("json")
        response = Net::HTTP.get(URI(CASKS_URL))
        JSON.parse(response).map { |package| package["token"] }
      end

      def cask?(package_name)
        cask_packages.include?(package_name)
      end
    end
  end

  class Winget < PackageManager
    class << self
      def install(package_name)
        winget("install", "-e", package_name)
      end
    end
  end

  class Apt < PackageManager
    class << self
      def install(package_name)
        apt("install", "-y", package_name)
      end

      def source(location)
        run("add-apt-repository", "-y", location)
        apt("update")
      end

      def sudo?
        true
      end
    end
  end

  class Snap < PackageManager
    class << self
      def install(package_name)
        snap("install", "--classic", package_name)
      end

      def sudo?
        true
      end
    end
  end

  class Dnf < PackageManager
    class << self
      def install(package_name)
        dnf("install", "-y", package_name)
      end

      def source(repo)
        if repo.key?("copr")
          source_copr(repo)
        else
          source_repo(repo)
        end
      end

      def sudo?
        true
      end

      private

      def source_copr(repo)
        dnf("copr", "enable", "-y", repo["copr"])
      end

      def source_repo(repo)
        return if repo_exists?(repo)

        repo_name = repo["name"].downcase.gsub(" ", "-")
        repo_file = "/etc/yum.repos.d/#{repo_name}.repo"
        repo_content = "[#{repo_name}]\n#{serialize(repo)}".inspect

        system("echo -e #{repo_content} | sudo tee #{repo_file} > /dev/null")
        dnf("update")
      end

      def repo_exists?(repo)
        Dir["/etc/yum.repos.d/*"].find do |file|
          File.read(file).match?(repo["baseurl"])
        end
      end

      def serialize(repo)
        array = repo.merge("gpgcheck" => 1, "enabled" => 1).to_a
        array.map { |key, value| [key, value].join("=") }.join("\n")
      end
    end
  end

  class Flatpak < PackageManager
    class << self
      def install(package_name)
        flatpak("install", "-y", "flathub", package_name)
      end

      def sudo?
        true
      end
    end
  end

  private_constant(
    :PackageManager,
    :Brew,
    :Winget,
    :Apt,
    :Snap,
    :Dnf,
    :Flatpak,
  )
end
