RSpec.describe Manufacturable::Factory do
  subject(:factory) { Class.new { extend Manufacturable::Factory } }

  let(:klass) { class_double('Klass') }
  let(:key) { 'key' }
  let(:args) { 'args' }

  describe '.manufactures' do
    subject(:manufactures) { factory.manufactures(klass) }

    before { manufactures }

    it 'remembers what type of factory it is' do
      expect(factory.instance_variable_get(:@type)).to eq(klass)
    end
  end

  describe '.build' do
    subject(:build) { factory.build(key, *args) }

    context 'when manufactures has NOT been called' do
      it { should be_nil }
    end

    context 'when manufactures has been called' do
      before do
        allow(Manufacturable::Builder).to receive(:build)
        factory.manufactures(klass)
        build
      end

      it 'delegates to the builder' do
        expect(Manufacturable::Builder).to have_received(:build).with(klass, key, args)
      end
    end
  end

  describe '.build_one' do
    subject(:build_one) { factory.build_one(key, *args) }

    context 'when manufactures has NOT been called' do
      it { should be_nil }
    end

    context 'when manufactures has been called' do
      before do
        allow(Manufacturable::Builder).to receive(:build_one)
        factory.manufactures(klass)
        build_one
      end

      it 'delegates to the builder' do
        expect(Manufacturable::Builder).to have_received(:build_one).with(klass, key, args)
      end
    end
  end

  describe '.build_many' do
    subject(:build_many) { factory.build_many(key, *args) }

    context 'when manufactures has NOT been called' do
      it { should be_empty }
    end

    context 'when manufactures has been called' do
      before do
        allow(Manufacturable::Builder).to receive(:build_many)
        factory.manufactures(klass)
        build_many
      end

      it 'delegates to the builder' do
        expect(Manufacturable::Builder).to have_received(:build_many).with(klass, key, args)
      end
    end
  end
end
