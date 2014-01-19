require 'spec_helper'

describe Like do
	before :each do
    @buddha = create :user
    @ananda = create :user, username: 'ananda'
    @sariputta = create :user, username: 'sariputta'
    @sit = create :sit, user: @buddha
	end
  
  context 'sits' do

  	it 'increments like count' do 
			expect(@sit.likes.count).to eq 0
  		@ananda.like! @sit
			expect(@sit.likes.count).to eq 1
  	end
 
 		it 'returns true for likes?' do
			expect(@ananda.likes? @sit).to eq false
  		@ananda.like! @sit
			expect(@ananda.likes? @sit).to eq true
		end

  	it 'list likers usernames' do
  		expect(@sit.likers.empty?).to eq true
  		@ananda.like! @sit
  		@sariputta.like! @sit
      
      expect(@sit.reload.likers.first).to be_a(User)
      expect(@sit.reload.likers.first.username).to eq('ananda')
      
      expect(@sit.reload.likers.last).to be_a(User)
      expect(@sit.reload.likers.last.username).to eq('sariputta')
  	end

  	it 'decrements like count' do 
  		@ananda.like! @sit
			expect(@sit.likes.count).to eq 1

			# Ananda unlikes buddhas sit
			@ananda.unlike! @sit.reload
			expect(@sit.likes.count).to eq 0
  	end

  	it 'returns false for likes?' do
      @ananda.like! @sit
      expect(@ananda.likes? @sit).to eq true

      @ananda.unlike! @sit
      expect(@ananda.likes? @sit).to eq false
    end
  end

  context 'comments' do
    before :each do
      @comment = create :comment, sit: @sit, user: @buddha
    end

    it 'increments like count' do 
      expect(@comment.likes.count).to eq 0
      @ananda.like! @comment
      expect(@comment.likes.count).to eq 1
    end
 
    it 'returns true for likes?' do
      expect(@ananda.likes? @comment).to eq false
      @ananda.like! @comment
      expect(@ananda.likes? @comment).to eq true
    end

    it 'list likers usernames' do
      expect(@comment.likers.empty?).to eq true
      @sariputta.like! @comment
      @ananda.like! @comment

      expect(@comment.reload.likers.first).to be_a(User)
      expect(@comment.reload.likers.first.username).to eq('sariputta')
      
      expect(@comment.reload.likers.last).to be_a(User)
      expect(@comment.reload.likers.last.username).to eq('ananda')
    end

    it 'decrements like count' do 
      @ananda.like! @comment
      expect(@comment.likes.count).to eq 1

      # Ananda unlikes buddhas sit
      @ananda.unlike! @comment.reload
      expect(@comment.likes.count).to eq 0
    end

    it 'returns false for likes?' do
      @ananda.like! @comment
      expect(@ananda.likes? @comment).to eq true

      @ananda.unlike! @comment
      expect(@ananda.likes? @comment).to eq false
    end
  end
end