module CloudFile
  class Evernote < Service
    register :provider => "evernote", :format => :evernote_html
    uri_format ":notebook/:title"
    
    fattr(:client) do
      EvernoteOAuth::Client.new(token: access_token)
    end
    fattr(:note_store) do
      client.note_store
    end

    def get_notebook(book)
      note_store.listNotebooks.find { |x| x.name == book }
    end
    def get_note_shell(book,title)
      book = get_notebook(book)

      filter = ::Evernote::EDAM::NoteStore::NoteFilter.new
      filter.notebookGuid = book.guid
      #filter.words = title
      notes = note_store.findNotes(filter,0,10)

      notes.notes.find { |x| x.title == title }
    end
    def get_note(book,title)
      shell = get_note_shell(book,title)
      unless shell
        raise "no note found"
      end

      note_store.getNote(shell.guid, true, true, false, false)
    end
    def create_note(book,title,content)
      note = ::Evernote::EDAM::Type::Note.new
      note.title = title
      #note.content = ""
      note.content = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>' + content + '</en-note>'
      note.notebookGuid = get_notebook(book).guid

      note_store.createNote(note)
    end
    def update_note(book,title,content)
      note = get_note(book,title)
      unless content =~ /DOCTYPE/
        content = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
        <en-note>' + content + '</en-note>'
      end
      note.content = content
      note_store.updateNote(note)
    end
    def write_note(book,title,content)
      if get_note_shell(book,title)
        update_note(book,title,content)
      else
        create_note(book,title,content)
      end
    end


    def read(loc)
      res = get_note(loc[:notebook],loc[:title]).content
      #raise "no match" unless res =~ /<en-note>(.*)<\/en-note>/
      #$1
    end
    def write(loc,content)
      write_note(loc[:notebook],loc[:title],content)
    end

    
    register_converter :evernote_html => :html do |str|
      raise "no match" unless str =~ /<en-note>(.*)<\/en-note>/
      $1
    end

  end
end