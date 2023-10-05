require 'rspec'
require 'hangman'

words = ['Hey', 'No', 'Barbie']

describe 'hangman tests' do
    describe 'get_word()' do
        it 'should return one word of words' do
            selected_word = get_word(words)
            expect(words).to include(selected_word)
        end
    end
end