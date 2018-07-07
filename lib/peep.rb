class Peep

  attr_reader :id, :content, :username, :time

  def initialize(id, content, username, time)
    @id = id
    @content = content
    @username = username
    @time = time
  end

  def self.create(user_id, content, time = Time.new)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: "chitter_test")
    else
      connection = PG.connect(dbname: "chitter")
    end
    result = connection.exec("INSERT INTO peeps (user_id, content, time) VALUES('#{user_id}','#{content}','#{time}')")
    #Peep.new(result.first['id'], result.first['content'], result.first['user_id'])
  end

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: "chitter_test")
    else
      connection = PG.connect(dbname: "chitter")
    end
    result = connection.exec("SELECT peeps.id, peeps.content, peeps.time, users.username FROM peeps INNER JOIN users ON peeps.user_id = users.id")
    result.map { |peep| Peep.new(peep['id'], peep['content'], peep['username'], peep['time']) }
  end

end
