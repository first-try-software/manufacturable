RSpec.describe Manufacturable do
  it "has a version number" do
    expect(Manufacturable::VERSION).not_to be nil
  end

  describe '.build' do
    subject(:build) { described_class.build(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build)

      build
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build).with(args)
    end
  end

  describe '.build_one' do
    subject(:build_one) { described_class.build_one(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build_one)

      build_one
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build_one).with(args)
    end
  end

  describe '.build_many' do
    subject(:build_many) { described_class.build_many(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build_all)

      build_many
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build_all).with(args)
    end
  end

  describe '.build_all' do
    subject(:build_all) { described_class.build_all(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build_all)

      build_all
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build_all).with(args)
    end
  end

  describe '.builds?' do
    subject(:builds?) { described_class.builds?(type, key) }

    let(:type) { :type }
    let(:key) { :key }

    before do
      allow(Manufacturable::Builder).to receive(:builds?)

      builds?
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:builds?).with(type, key)
    end
  end

  describe '.registered_types' do
    subject(:registered_types) { described_class.registered_types }

    before do
      allow(Manufacturable::Registrar).to receive(:registered_types)

      registered_types
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:registered_types).with(no_args)
    end
  end

  describe '.registered_keys' do
    subject(:registered_keys) { described_class.registered_keys(type) }

    let(:type) { 'type' }

    before do
      allow(Manufacturable::Registrar).to receive(:registered_keys)

      registered_keys
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:registered_keys).with(type)
    end
  end

  describe '.reset!' do
    subject(:reset!) { described_class.reset! }

    before do
      allow(Manufacturable::Registrar).to receive(:reset!)

      reset!
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:reset!)
    end
  end

  describe '.config' do
    subject(:config) { described_class.config(&block) }

    let(:block) { Proc.new {} }

    before do
      allow(Manufacturable::Config).to receive(:load_paths)
    end

    it 'calls the block with the config class' do
      described_class.config { |arg| expect(arg).to eq(Manufacturable::Config) }
    end

    it 'loads the configured paths' do
      config

      expect(Manufacturable::Config).to have_received(:load_paths)
    end
  end
end
