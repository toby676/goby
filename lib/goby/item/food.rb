require 'goby'

module Goby

  # Recovers HP when used.
  class Food < Item

    # @param [String] name the name.
    # @param [Integer] price the cost in a shop.
    # @param [Boolean] consumable upon use, the item is lost when true.
    # @param [Boolean] disposable allowed to sell or drop item when true.
    # @param [Integer] recovers the amount of HP recovered when used.
    def initialize(name: "Food", price: 0, consumable: true, disposable: true, recovers: 0)
      super(name: name, price: price, consumable: consumable, disposable: disposable)
      @recovers = recovers
    end

    # Heals the entity.
    #
    # @param [Entity] user the one using the food.
    # @param [Entity] entity the one on whom the food is used.
    def use(user, entity)
      if heal_takes_entity_over_max_hp(entity)
        recover_amount = entity.stats[:max_hp] - entity.stats[:hp]
        entity.set_stats(hp: entity.stats[:max_hp])
      else
        recover_amount = @recovers
        entity.set_stats(hp: (entity.stats[:hp] + @recovers))
      end

      # Helpful output.
      print "#{user.name} uses #{name}"
      if (user == entity)
        print " and "
      else
        print " on #{entity.name}!\n#{entity.name} "
      end
      print "recovers #{recover_amount} HP!\n\n"
      print "#{entity.name}'s HP: #{entity.stats[:hp]}/#{entity.stats[:max_hp]}\n\n"

    end

    # The amount of HP that the food recovers.
    attr_reader :recovers
    private

    def heal_takes_entity_over_max_hp(entity)
      entity.stats[:hp] + recovers > entity.stats[:max_hp]
    end
  end

end
