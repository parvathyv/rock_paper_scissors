

  # Having some fun discovering possible use of classes to solve Rock, Paper,
  # Scissors with some additional functionlity as shown below, still gaining
  # an understanding of classes in Ruby and OOPS in general, this version is
  # mainly to get feedback on understanding of some basic concepts and
  # correct mistakes.

=begin
  ----------------------------------------------------------------------------

  Enter point limit for game
  2

  parvathyiyer score : 0
  parvathys-air.home score : 0
  Choose Rock(r) : Paper(p) : Scissors(s) : Spock(k) : Lizard(l) l
  parvathyiyer chose Lizard
  parvathys-air.home chose Rock
  Rock crushes Lizard, parvathys-air.home wins round !


  parvathyiyer score : 0
  parvathys-air.home score : 1
  Choose Rock(r) : Paper(p) : Scissors(s) : Spock(k) : Lizard(l) k
  parvathyiyer chose Spock
  parvathys-air.home chose Paper
  Paper disproves Spock, parvathys-air.home wins round !

  parvathys-air.home wins Game 1 !

  parvathys-air.home.set_message : Ken Jenningsism => I for one welcome our
  computer overlords !


  2 round(s) were played this game

  Homo Sapien chose ["Lizard", "Spock"]
  {"Lizard"=>"50 %", "Spock"=>"50 %"}
  Computer chose ["Rock", "Paper"]
  {"Paper"=>"50 %", "Rock"=>"50 %"}

  Would you like another go ?( Enter y if yes )
  n

  --------------------------------------------------------------------------

=end

  require 'Socket'

    class Game
      attr_accessor :name
      attr_reader :point_limit, :rounds_played


      def initialize(point_limit)
        @point_limit=point_limit
        @rounds_played=0
      end

      def round_incrementor
        @rounds_played+=1
      end


      def round_winner?(entry)

        win_hash ={

          "Paper, Rock" => "Paper covers Rock",
          "Rock, Scissors" => "Rock smashes Scissors",
          "Scissors, Paper" => "Scissors cut Paper",
          "Rock, Lizard" => "Rock crushes Lizard",
          "Lizard, Spock" => "Lizard poisons Spock",
          "Spock, Scissors" => "Spock smashes Scissors",
          "Scissors, Lizard" => "Scissors decapitate Lizard",
          "Lizard, Paper" => "Lizard eats Paper",
          "Paper, Spock" => "Paper disproves Spock",
          "Spock, Rock" => "Spock vaporizes Rock"
        }

        win_hash[entry] if win_hash.key?(entry)

      end


    end


    class Player

      attr_accessor :name
      attr_reader :points_earned, :entries, :type

      def initialize(type)
        @points_earned=0
        @entries=[]
        @type=type
        @arr={}
      end

      def points_incrementor
        @points_earned+=1
      end


      def log_entries(choice)
        @entries<<choice
      end

      def calc_choice_percentages

        @entries.uniq.sort.each do|x|
            ch_cnt=@entries.count(x).to_f
            tot_cnt=@entries.size.to_f
            @arr[x]="#{(ch_cnt/tot_cnt*100).round} %"
        end

        @arr
       end

    end


    class Human_Player < Player


        MESSAGE=["Way to go Champ !!","The machines are not taking over ! ",
        "You sure you won ?",
        "How long can you keep this up ?"]

        CHOICE_HASH ={
        'r' => 'Rock',
        'p' => 'Paper',
        's' => 'Scissors',
        'k' => 'Spock',
        'l' => 'Lizard'
        }


        def initialize(type)
          super(type)
        end

        def get_round_entry(entry)
          CHOICE_HASH[entry]
        end



        def get_message_wins
          MESSAGE[rand(4)]
        end


    end


    class Computer_Player < Player

      MESSAGE=["self.high_five !!","The machines are taking over !! ",
        "Ken Jenningsism => I for one welcome our computer overlords ! ",
        "Anything you can do I can do better..","Why bother trying ?",
        "The truth of the matter is..."]

      CHOICE_HASH ={
                    0 => 'Rock',
                    1 => 'Paper',
                    2=> 'Scissors',
                    3=> 'Spock',
                    4 => 'Lizard'
                    }


      def initialize(type)
        super(type)
      end

      def get_round_entry
        CHOICE_HASH[rand(5)]
      end

      def get_message_wins
        MESSAGE[rand(6)]
      end

    end


    # main begins
    ctr=1
    # variable to check if multiple games are to be played
    ans='y'
    while ans=='y'

    round_limit=nil

      while !(round_limit.is_a?Integer)
        puts "Enter point limit for game"
        round_limit=gets.chomp.to_i
      end

      game=Game.new(round_limit)
      game.name="Game #{ctr}"

      ctr+=1

      player=Human_Player.new('Homo Sapien')
      player.name=ENV['USER']
      computer=Computer_Player.new('Computer')
      computer.name=Socket.gethostname

      pl_score= player.points_earned
      co_score=computer.points_earned

      while pl_score < game.point_limit && co_score < game.point_limit

        puts $/

        puts "#{player.name} score : #{pl_score}"
        puts "#{computer.name} score : #{co_score}"

        print "Choose Rock(r) : Paper(p) : Scissors(s) : Spock(k) : Lizard(l) "
        pl=gets.chomp
        pl=player.get_round_entry(pl)

        if pl==nil
          result='Invalid entry, Try again.'
        else
          game.round_incrementor
          rounds_played=game.rounds_played

          puts "#{player.name} chose #{pl}"
          player.log_entries(pl)
          co=computer.get_round_entry
          puts "#{computer.name} chose #{co}"
          computer.log_entries(co)

          if pl!=co
            check_entries="#{pl}, #{co}"
              if rule_msg=game.round_winner?(check_entries)
                player.points_incrementor
                winner=player.name
                msg= "#{player.name}.set_message : #{player.get_message_wins}"
                puts $/

              else
                check_entries="#{co}, #{pl}"
                if rule_msg=game.round_winner?(check_entries)
                  computer.points_incrementor
                  winner=computer.name
                  cmsg=computer.get_message_wins
                  msg="#{computer.name}.set_message : #{cmsg}"
                  puts $/

                end

              end

              result= "#{rule_msg}, #{winner} wins round !"

            else
              result= 'Tie, Try again.'
            end

          end

        pl_score= player.points_earned
        co_score=computer.points_earned

        puts result,$/

        end


      puts "#{winner} wins #{game.name} !",$/
      puts msg,$/

      puts "#{rounds_played} round(s) were played this game",$/


      puts "#{player.type} chose #{player.entries}"
            puts player.calc_choice_percentages
      puts "#{computer.type} chose #{computer.entries}"
            puts computer.calc_choice_percentages,$/

      puts "Would you like another go ?( Enter y if yes )"
      ans=gets.chomp
      puts $/


    end
