RSpec.describe Manufacturable::Registrar do
  subject(:registrar) { described_class }

  let(:type) { :type }
  let(:key) { :key }
  let(:klass) { class_double('Klass') }

  let(:clear_registry) { registrar.instance_variable_get(:@registry)&.clear }

  before { clear_registry }
  after { clear_registry }

  describe '.register' do
    subject(:register) { registrar.register(type, key, klass) }

    before { register }

    it 'adds the class to the registry under the type and key' do
      expect(registrar.get(type, key)).to include(klass)
    end
  end

  describe '.get' do
    subject(:get) { registrar.get(type, key) }

    context 'when the type does NOT exist in the registry' do
      it 'returns an empty set' do
        expect(get).to be_a_kind_of(Set).and(be_empty)
      end
    end

    context 'when the type exists in the registry' do
      context 'and the set corresponding to the type and key is empty' do
        before { registrar.register(type, :key2, klass) }

        context 'and there is NOT a default set' do
          it 'returns an empty set' do
            expect(get).to be_empty
          end
        end

        context 'and there is a default set' do
          let(:default_klass) { class_double('DefaultKlass') }

          before { registrar.register(type, Manufacturable::Registrar::DEFAULT_KEY, default_klass) }

          it 'returns the default set' do
            expect(get).to include(default_klass)
          end
        end
      end

      context 'and the set corresponding to the type and key is NOT empty' do
        let(:all_klass) { class_double('AllKlass') }

        before do
          registrar.register(type, Manufacturable::Registrar::ALL_KEY, all_klass)
          registrar.register(type, key, klass)
        end

        it 'returns a set containing all types registered for that type' do
          expect(get).to include(all_klass)
        end

        it 'returns a set containing all types registered for that key' do
          expect(get).to include(klass)
        end
      end
    end
  end

  describe '.registered_types' do
    subject(:registered_types) { registrar.registered_types }

    before { registrar.register(type, key, klass) }

    it 'returns the registered types' do
      expect(registered_types).to eq([type])
    end
  end

  describe '.registered_keys' do
    subject(:registered_keys) { registrar.registered_keys(type) }

    before { registrar.register(type, key, klass) }

    it 'returns the registered keys for the type' do
      expect(registered_keys).to eq([key])
    end
  end
end
