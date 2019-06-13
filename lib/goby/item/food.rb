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
    def use(food_giver, food_consumer)
      if heal_takes_entity_over_max_hp(food_consumer)
        recovery_amount = food_consumer.stats[:max_hp] - food_consumer.stats[:hp]
        food_consumer.heal_by(recovery_amount)
      else
        recovery_amount = @recovers
        food_consumer.heal_by(recovery_amount)
      end

      # Helpful output.
      print "#{food_giver.name} uses #{name}"
      if (food_giver == food_consumer)
        print " and "
      else
        print " on #{food_consumer.name}!\n#{food_consumer.name} "
      end
      print "recovers #{recovery_amount} HP!\n\n"
      print "#{food_consumer.name}'s HP: #{food_consumer.stats[:hp]}/#{food_consumer.stats[:max_hp]}\n\n"

    end

    # The amount of HP that the food recovers.
    attr_reader :recovers
    private

    def heal_takes_entity_over_max_hp(entity)
      entity.stats[:hp] + recovers > entity.stats[:max_hp]
    end
  end

end
