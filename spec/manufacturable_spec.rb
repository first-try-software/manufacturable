RSpec.describe Manufacturable do
  it "has a version number" do
    expect(Manufacturable::VERSION).not_to be nil
  end

  describe '.build' do
    subject(:build) { Manufacturable.build(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build)

      build
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build).with(args)
    end
  end

  describe '.registered_types' do
    subject(:registered_types) { Manufacturable.registered_types }

    before do
      allow(Manufacturable::Registrar).to receive(:registered_types)

      registered_types
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:registered_types).with(no_args)
    end
  end

  describe '.registered_keys' do
    subject(:registered_keys) { Manufacturable.registered_keys(type) }

    let(:type) { 'type' }

    before do
      allow(Manufacturable::Registrar).to receive(:registered_keys)

      registered_keys
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:registered_keys).with(type)
    end
  end

  describe '.config' do
    subject(:config) { Manufacturable.config(&block) }

    let(:block) { Proc.new {} }

    before do
      allow(Manufacturable::Config).to receive(:load_paths)
    end

    it 'calls the block with the config class' do
      Manufacturable.config { |arg| expect(arg).to eq(Manufacturable::Config) }
    end

    it 'loads the configured paths' do
      config

      expect(Manufacturable::Config).to have_received(:load_paths)
    end
  end
end
