RSpec.describe Manufacturable::Builder do
  describe '.build' do
    subject(:build) { described_class.build(type, key, args) }

    let(:type) { 'type' }
    let(:key) { 'key' }
    let(:args) { 'args' }
    let(:klasses) { Set.new }

    before do
      allow(Manufacturable::Registrar).to receive(:get).and_return(klasses)
    end

    it 'gets the classes from the Registrar' do
      build

      expect(Manufacturable::Registrar).to have_received(:get).with(type, key)
    end

    context 'when the class set is empty' do
      let(:klasses) { Set.new }

      it { should be_nil }
    end

    context 'when the class set is NOT empty' do
      let(:klass) { class_double('Klass', new: klass_instance) }
      let(:klass_instance) { instance_double('Klass') }
      let(:klasses) { Set.new([klass]) }

      context 'and the set contains one klass' do
        it 'instantiates an object with the provided args' do
          build

          expect(klass).to have_received(:new).with(args)
        end

        it 'returns an instance of the first class in the set' do
          expect(build).to eq(klass_instance)
        end
      end

      context 'and the set contains more than one klass' do
        let(:klass1) { class_double('Klass1', new: klass1_instance) }
        let(:klass2) { class_double('Klass2', new: klass2_instance) }
        let(:klass1_instance) { instance_double('Klass1') }
        let(:klass2_instance) { instance_double('Klass2') }
        let(:klasses) { Set.new([klass1, klass2]) }

        it 'instantiates an object with the provided args' do
          build

          expect(klasses).to all(have_received(:new).with(args))
        end

        it 'returns an instance of every class in the set' do
          expect(build).to eq([klass1_instance, klass2_instance])
        end
      end
    end
  end
end