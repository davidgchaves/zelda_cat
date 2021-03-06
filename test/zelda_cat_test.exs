defmodule ZeldaCatTest do
  use ExUnit.Case

  test "when we make a new entity and add a HealthComponent, the hp increases" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, HealthComponent, 100

    assert HealthComponent.get_hp(entity) == 100
  end

  test "when we make a new entity and add a HealthComponent, the entity is alive" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, HealthComponent, 100

    assert HealthComponent.alive?(entity) == true
  end

  test "when we send a 'hit' event to the entity, the hp diminishes" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, HealthComponent, 100

    Entity.notify entity, {:hit, 75}
    assert HealthComponent.get_hp(entity) == 25
  end

  test "when we send a 'heal' event to the entity, the hp increases" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, HealthComponent, 50

    Entity.notify entity, {:heal, 100}
    assert HealthComponent.get_hp(entity) == 150
  end

  test "when hp hits 0, the entity is dead" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, HealthComponent, 100
    Entity.notify entity, {:hit, 100}

    assert HealthComponent.alive?(entity) == false
  end

  test "when we create an entity and add a XYComponent, the entity is positioned" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, XYComponent, {50, 50}

    assert XYComponent.get_position(entity) == {50, 50}
  end

  test "when we send a 'move_to' event with a 'y' coordinate to the entity, it moves in the y-axis" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, XYComponent, {50, 50}

    Entity.notify entity, {:move_to, {:y, 35}}
    assert XYComponent.get_position(entity) == {50, 35}
  end

  test "when we send a 'move_to' event with a 'x' coordinate to the entity, it moves in the x-axis" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, XYComponent, {50, 50}

    Entity.notify entity, {:move_to, {:x, 35}}
    assert XYComponent.get_position(entity) == {35, 50}
  end

  test "when we create an entity and add a WeaponComponent, the entity starts with an empty list of weapons" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, WeaponComponent, []

    assert WeaponComponent.list_available_weapons(entity) == []
  end

  test "when we send two 'add_weapon' events to the entity, the entity gets two new weapons" do
    {:ok, entity} = Entity.init
    Entity.add_component entity, WeaponComponent, []

    Entity.notify entity, {:add_weapon, "fende testas"}
    Entity.notify entity, {:add_weapon, "fouce"}
    assert WeaponComponent.list_available_weapons(entity) == ["fende testas", "fouce"]
  end
end
