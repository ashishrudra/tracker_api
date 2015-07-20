module GG
  describe Config do
    before(:each) do
      @config_path = File.join(GG.root, "config")
      @local_config_path = File.join(GG.root, "config", "local")
      allow(File).to receive(:exist?)
    end

    describe "::data" do
      context "env" do
        it "returns upcased env variables" do
          ENV["_TEST"] = "env-value"
          expect(Config.data("_TEST")).to eq("env-value")
        end

        it "returns array env variables" do
          ENV["_TEST"] = "[one,two]"
          expect(Config.data("_TEST")).to eq(["one", "two"])
        end
      end

      it "returns LocalConfig data when config is enabled" do
        config = Sonoma::LocalConfig::Config.new("LOCAL_CONFIG", { "data" => "local_data" })

        expect(Sonoma::LocalConfig).to receive(:when_enabled).with("LOCAL_CONFIG").and_yield(config)
        expect(Config.data("LOCAL_CONFIG")).to eq("local_data")
      end

      it "does not cache LocalConfig values" do
        config = Sonoma::LocalConfig::Config.new("FOO", { "data" => "value" })
        allow(Sonoma::LocalConfig).to receive(:when_enabled).with("FOO").and_yield(config)

        expect(Config.data("FOO")).to eq("value")

        config = Sonoma::LocalConfig::Config.new("FOO", { "data" => "updated_value" })
        allow(Sonoma::LocalConfig).to receive(:when_enabled).with("FOO").and_yield(config)

        expect(Config.data("FOO")).to eq("updated_value")
      end

      it "preferences ENV values over LocalConfig" do
        config = Sonoma::LocalConfig::Config.new("FOO", { "data" => "local_data" })
        expect(Sonoma::LocalConfig).to receive(:when_enabled).with("FOO").and_yield(config)
        expect(Config.data("FOO")).to eq("local_data")

        ENV["FOO"] = "ENV_DATA"
        expect(Config.data("FOO")).to eq("ENV_DATA")
      end

      it "raises error when not exists" do
        expect { Config.data("RANDOM") }.to raise_error(/no config/i)
      end
    end

    describe "::enabled?" do
      context "env" do
        it "returns true when value is 'true'" do
          ENV["FOO"] = "true"
          expect(Config.enabled?(:FOO)).to be_truthy
        end

        it "returns false when value is not 'true'" do
          ENV["FOO"] = "random"
          expect(Config.enabled?(:FOO)).to be_falsy
        end
      end

      it "calls Sonoma::LocalConfig.enabled? when it's not present in ENV" do
        config_name = "random_config"
        expect(Sonoma::LocalConfig).to receive(:enabled?).with(config_name.to_sym)
        Config.enabled?(config_name)
      end

      context "overwrites local config with ENV value" do
        it "overwrites truthy value" do
          allow(Sonoma::LocalConfig).to receive(:enabled?).and_return(false)
          ENV["FOO"] = "true"
          expect(Config.enabled?(:FOO)).to be_truthy
        end

        it "overwrites falsy value" do
          allow(Sonoma::LocalConfig).to receive(:enabled?).and_return(true)
          ENV["FOO"] = "false"
          expect(Config.enabled?(:FOO)).to be_falsy
        end
      end
    end

    describe "::file" do
      after(:each) do
        Config.instance_variable_get("@checked_in_file_cache").clear
      end

      def stub_checked_in_file!(name, file_string)
        file_path = File.join(@config_path, name)
        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow(IO).to receive(:read).with(file_path).and_return(file_string)
      end

      it "returns file data from config/{method_name}.yml" do
        stub_checked_in_file!("yaml_example.yml", "foo: bar")
        expect(Config.file("yaml_example")).to eq({ "foo" => "bar" })
      end

      it "returns erb-erlizes files" do
        stub_checked_in_file!("erb_example.erb.yml", "foo: <%= 2 %>")
        expect(Config.file("erb_example")).to eq({ "foo" => 2 })
      end

      it "returns data as a dottable hash" do
        stub_checked_in_file!("yaml_example.yml", "foo: bar")
        expect(Config.file("yaml_example").foo).to eq("bar")
      end

      it "returns top-level arrays as arrays" do
        stub_checked_in_file!("array.yml", "- foo")
        expect(Config.file("array")).to eq(["foo"])
      end

      it "caches checked in file values" do
        stub_checked_in_file!("yaml_example.yml", "data: original")
        expect(Config.file("yaml_example").data).to eq("original")
        stub_checked_in_file!("yaml_example.yml", "data: new")
        expect(Config.file("yaml_example").data).to eq("original")
      end
    end
  end
end
