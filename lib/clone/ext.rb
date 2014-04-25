module ARGVEXT

  module EXTENSION

    def to_hash opts= {}
      raise(ArgumentError) unless opts.class <= Hash

      opts[:sym_key]      ||= opts[:sk] ||  opts[:sym]  || opts[:s]
      opts[:multi_value]  ||= opts[:mv] ||  opts[:m]

      return_obj= {}
      self.count.times do |index|
        unless opts[:multi_value]

          next if self[index+1].nil?
          if self[index][0].include?('-') && !self[index+1][0].include?('-')
            return_obj[( opts[:sym_key] ?  self[index].to_s.dup.gsub!(/^-*/,'').to_sym :  self[index] )]= self[index+1]
          end

        else

          begin

            if self[index][0].include?('-') && !self[index+1][0].include?('-')

              new_element= []
              index_at= index+1
              loop do
                if self[index_at].nil? || self[index_at].to_s[0].include?('-')
                  break
                else
                  new_element.push(self[index_at])
                end
                index_at += 1
              end
              return_obj[( opts[:sym_key] ?  self[index].to_s.dup.gsub!(/^-*/,'').to_sym :  self[index] )]= new_element

            end

          rescue
          end


        end
      end
      return return_obj

    end

    alias :flagtag    :to_hash
    alias :flagtags   :to_hash

    def flags
      self.select { |e| e[0].include?('-') }
    end

    alias :flag :flags
    alias :tags :flags
    alias :keys :flags

    def sym_flags
      self.flags.map { |e| e.to_s.dup.gsub!(/^-*/,'').to_sym }
    end

    alias :flag_syms  :sym_flags
    alias :flag_sym   :sym_flags
    alias :tag_syms   :sym_flags
    alias :key_syms   :sym_flags

    def values
      self.select { |e| !e[0].include?('-') }
    end

  end

end
ARGV.__send__ :extend,ARGVEXT::EXTENSION