const onDropUserStory = (featureIndex: number, epicIndex: number) => {
    const newEpics = [...epics]
    const userStoryCard = props.userStoryCard
    const featureUserStories =
      newEpics[epicIndex].features[featureIndex].userStories

    newEpics[epicIndex].features[featureIndex].userStories.pop()
    newEpics[epicIndex].features[featureIndex].userStories = [
      ...featureUserStories,
      {
        id: userStoryCard.id,
        name: userStoryCard.name,
        functional: userStoryCard.functional,
        who: userStoryCard.who,
        what: userStoryCard.what,
        why: userStoryCard.why,
      },
    ]
    newEpics[epicIndex].features[featureIndex].userStories.push({
      id: 0,
      name: '',
      functional: '',
      who: '',
      what: '',
      why: '',
    })

    const element = document.getElementById('user-story-' + userStoryCard.id)
    element?.classList.add('dropped-user-story')
    element?.setAttribute('draggable', 'false')

    setEpics(newEpics)
  }