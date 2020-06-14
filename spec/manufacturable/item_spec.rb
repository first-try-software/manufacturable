RSpec.describe Manufacturable::Item do
  subject(:item) { Class.new(base_klass) { extend Manufacturable::Item } }

  let(:base_klass) { Class.new }
  let(:type) { base_klass }

  before do
    allow(Manufacturable::Registrar).to receive(:register)
  end

  describe '.corresponds_to' do
    subject(:corresponds_to) { item.corresponds_to(*args) }

    let(:args) { [key] }

    before { corresponds_to }

    context 'when the type is NOT provided' do
      context 'when the key does NOT match the item type' do
        let(:key) { :key }

        it 'registers itself with the key' do
          expect(Manufacturable::Registrar).to have_received(:register).with(type, key, item)
        end
      end

      context 'when the key matches the item type' do
        let(:key) { type }

        it 'registers itself for all items of that type' do
          expect(Manufacturable::Registrar).to have_received(:register).with(type, Manufacturable::Registrar::ALL_KEY, item)
        end
      end
    end

    context 'when the type is provided' do
      let(:args) { [key, explicit_type] }
      let(:key) { :key }
      let(:explicit_type) { :explicit_type }

      it 'registers itself with the key and type' do
        expect(Manufacturable::Registrar).to have_received(:register).with(explicit_type, key, item)
      end
    end
  end

  describe '.corresponds_to_all' do
    subject(:corresponds_to_all) { item.corresponds_to_all(*args) }

    let(:args) { [] }

    before { corresponds_to_all }

    it 'registers itself for all items of that type' do
      expect(Manufacturable::Registrar).to have_received(:register).with(type, Manufacturable::Registrar::ALL_KEY, item)
    end

    context 'when the type is provided' do
      let(:args) { [explicit_type] }
      let(:explicit_type) { :explicit_type }

      it 'registers itself for all items of the specified type' do
        expect(Manufacturable::Registrar).to have_received(:register).with(explicit_type, Manufacturable::Registrar::ALL_KEY, item)
      end
    end
  end

  describe '.default_manufacturable' do
    subject(:default_manufacturable) { item.default_manufacturable(*args) }

    let(:args) { [] }

    before { default_manufacturable }

    it 'registers itself as the default item for that type' do
      expect(Manufacturable::Registrar).to have_received(:register).with(type, Manufacturable::Registrar::DEFAULT_KEY, item)
    end

    context 'when the type is provided' do
      let(:args) { [explicit_type] }
      let(:explicit_type) { :explicit_type }

      it 'registers itself as the default item for the specified type' do
        expect(Manufacturable::Registrar).to have_received(:register).with(explicit_type, Manufacturable::Registrar::DEFAULT_KEY, item)
      end
    end
  end
end
