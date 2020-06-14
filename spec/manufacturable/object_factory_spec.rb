RSpec.describe Manufacturable::ObjectFactory do
  subject(:factory) { described_class }

  describe '.build' do
    subject(:build) { factory.build(key, *args) }

    let(:key) { :key }
    let(:args) { [1, 2, 3] }

    before do
      allow(Manufacturable::Builder).to receive(:build)

      build
    end

    it 'delegates to the builder with the correct arguments' do
      expect(Manufacturable::Builder).to have_received(:build).with(Object, key, *args)
    end
  end
end
