require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき'
    it 'nickname,email,passwordとconfirmationが存在すれば登録できる' do
    expect(@user).to be_valid
    end
    it 'nicknameが6文字以下であれば登録できる' do
      @user.nickname = 'aaaaaa'
      expect(@user).to be_valid
    end
    it 'passwordが6文字かつ英数字であれば登録できる' do
      @user.password = '000aaa'
      @user.password_confirmation = '000aaa'
      expect(@user).to be_valid
    end
  end

  context '新規登録ができないとき' do
    it 'nicknameが空のとき登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end
    it 'nicknameが7文字以上のとき登録できない' do
      @user.nickname = '000aaaa'
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname is too long (maximum is 6 characters)")
    end
    it 'emailが空のときは登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    it 'emailが重複したときは登録できない' do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include("Email has already been taken")
    end
    it 'emailに@を含まれないと登録できない' do
      @user.email = 'aaaaa.com'
      @user.valid?
      expect(@user.errors.full_messages).to include("Email is invalid")
    end
    it 'passwordが空のときは登録できない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it 'passwordが5文字以下では登録できない' do
      @user.password = '000aa'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
    it 'passwordが存在してもpassword_confirmaionが存在しないと登録できない' do
      @user.password_confirmation = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
  end
end
