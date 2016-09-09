class User
  include Hanami::Entity
end

class Avatar
  include Hanami::Entity
end

class Author
  include Hanami::Entity
end

class Book
  include Hanami::Entity
end

class Operator
  include Hanami::Entity
end

class SourceFile
  include Hanami::Entity
end

class UserRepository < Hanami::Repository
  relation(:users) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       User
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def find(id)
    users.by_id(id).as(:entity).one
  end

  def _create_with_rescue(*args)
    _create_without_rescue(*args)
  rescue => e
    raise Hanami::Model::Error.for(e)
  end

  alias _create_without_rescue create
  alias create _create_with_rescue

  private :_create_without_rescue
  private :_create_with_rescue

  def _update_with_rescue(*args)
    _update_without_rescue(*args)
  rescue => e
    raise Hanami::Model::Error.for(e)
  end

  alias _update_without_rescue update
  alias update _update_with_rescue

  private :_update_without_rescue
  private :_update_with_rescue

  def _delete_with_rescue(*args)
    _delete_without_rescue(*args)
  rescue => e
    raise Hanami::Model::Error.for(e)
  end

  alias _delete_without_rescue delete
  alias delete _delete_with_rescue

  private :_delete_without_rescue
  private :_delete_with_rescue

  def all
    users.as(:entity)
  end

  def first
    users.as(:entity).first
  end

  def last
    users.order(Sequel.desc(users.primary_key)).as(:entity).first
  end

  def clear
    users.delete
  end

  def by_name(name)
    users.where(name: name).as(:entity)
  end
end

class AvatarRepository < Hanami::Repository
  relation(:avatars) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Avatar
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def find(id)
    users.by_id(id).as(:entity).one
  end

  def _create_with_rescue(*args)
    _create_without_rescue(*args)
  rescue => e
    raise Hanami::Model::Error.for(e)
  end

  alias _create_without_rescue create
  alias create _create_with_rescue

  private :_create_without_rescue
  private :_create_with_rescue

  def _update_with_rescue(*args)
    _update_without_rescue(*args)
  rescue => e
    raise Hanami::Model::Error.for(e)
  end

  alias _update_without_rescue update
  alias update _update_with_rescue

  private :_update_without_rescue
  private :_update_with_rescue
end

class AuthorRepository < Hanami::Repository
  relation(:authors) do
    schema(infer: true) do
      associations do
        has_many :books
      end
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Author
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]
  relations :books

  def find(id)
    authors.by_id(id).as(:entity).one
  end

  def find_with_books(id)
    aggregate(:books).where(authors__id: id).as(Author).one
  end

  def books_for(author)
    assoc(:books, author)
  end

  def add_book(author, data)
    assoc(:books, author).add(data)
  end

  def remove_book(author, id)
    assoc(:books, author).remove(id)
  end

  def delete_books(author)
    assoc(:books, author).delete
  end

  def delete_on_sales_books(author)
    assoc(:books, author).where(on_sale: true).delete
  end

  def books_count(author)
    assoc(:books, author).count
  end

  def on_sales_books_count(author)
    assoc(:books, author).where(on_sale: true).count
  end

  def find_book(author, id)
    book_for(author, id).one
  end

  def book_exists?(author, id)
    book_for(author, id).exists?
  end

  private

  def book_for(author, id)
    assoc(:books, author).where(id: id)
  end

  def assoc(target, subject)
    Hanami::Model::Association.new(self, target, subject)
  end
end

class BookRepository < Hanami::Repository
  relation(:books) do
    schema(infer: true) do
      associations do
        belongs_to :author
      end
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Book
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def find(id)
    books.by_id(id).as(:entity).one
  end
end

class OperatorRepository < Hanami::Repository
  relation(:t_operator) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Operator
    register_as :entity

    attribute :id,   from: :operator_id
    attribute :name, from: :s_name
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def find(id)
    t_operator.by_id(id).as(:entity).one
  end

  def all
    t_operator.as(:entity)
  end

  def first
    t_operator.as(:entity).first
  end

  def last
    t_operator.order(Sequel.desc(t_operator.primary_key)).as(:entity).first
  end

  def clear
    t_operator.delete
  end
end

class SourceFileRepository < Hanami::Repository
  relation(:source_files) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       SourceFile
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:timestamps, :mapping]

  def find(id)
    root.by_id(id).as(:entity).one
  end
end

Hanami::Model.load!
