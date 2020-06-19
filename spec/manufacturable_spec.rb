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

  describe '.build_one' do
    subject(:build_one) { Manufacturable.build_one(args) }

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
    subject(:build_many) { Manufacturable.build_many(args) }

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
    subject(:build_all) { Manufacturable.build_all(args) }

    let(:args) { 'args' }

    before do
      allow(Manufacturable::Builder).to receive(:build_all)

      build_all
    end

    it 'delegates to the Builder' do
      expect(Manufacturable::Builder).to have_received(:build_all).with(args)
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

  describe '.reset!' do
    subject(:reset!) { Manufacturable.reset! }

    before do
      allow(Manufacturable::Registrar).to receive(:reset!)

      reset!
    end

    it 'delegates to the Registrar' do
      expect(Manufacturable::Registrar).to have_received(:reset!)
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
