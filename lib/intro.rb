Tale.chapter "Intro" do

  location :tavern

  event "approach the tavern" do
    detail "You ride up to the tavern exhausted. It looks like a pile of wood and stone blew into place in the last storm, and would blow right back out of place in the next."
  end

  event "step into the tavern" do
    detail "Stepping up to the door you hear the din of battle from inside. Shadows play frantically accross the backlit windows."
    action key: :open_door, label: "Open the door"
  end

  event "open the door" do
    detail "As you step in the door you catch a flash from the corner of your eye: a chair is flying towards you."
    action key: :duck, label: "Duck!"
    action key: :swing, label: "Swing"
  end

  event "take damage from chair" do
    detail "You "
  end

end

Tale.chapter "Diver's Den" do

end