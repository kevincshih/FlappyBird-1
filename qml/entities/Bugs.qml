import VPlay 2.0
import QtQuick 2.0

EntityBase {
  id: bugElement
  width: spriteBug.width
  height: spriteBug.height

  property int variationDistance: 70
  property double delay: 0

  opacity: calculateOpacity()

  MultiResolutionImage {
    id: spriteBug
    y: scene.height/2
    source: "../../assets/img/bug.png"
  }

  Item{
  clip:true
  width:spriteBug.width
  height:spriteBug.height
  y: scene.height/2
  }

  BoxCollider {
    id: collider
    width: spriteBug.width
    height: spriteBug.height
    anchors.centerIn: spriteBug
    bodyType: Body.Static
    collisionTestingOnlyMode: true
    fixture.onBeginContact: {
      player.gameOver()
    }
  }

  MovementAnimation {
    id: animation
    target: parent
    property: "x"
    velocity: -150
    running: false
    minPropertyValue: scene.gameWindowAnchorItem.x-bugElement.width*1.5
    onLimitReached: {
      reset()
  }
  }

  function calculateOpacity() {
      return player.calculateOpacity(bugElement.x)
  }

  function generateRandomValueBetween(minimum, maximum) {
    return Math.random()*(maximum-minimum) + minimum
  }

  function reset() {
    bugElement.x = scene.gameWindowAnchorItem.width+bugElement.width/2
    bugElement.y = generateRandomValueBetween(-variationDistance, variationDistance)-scene.height/3
  }

  function start() {
    delayTimer.restart()
  }

  function stop() {
    animation.stop()
    delayTimer.stop()
  }

  Timer {
    id: delayTimer
    interval: delay*1000
    repeat: false
    onTriggered: {
      animation.start()
    }
  }

  Component.onCompleted: {
    reset()
  }
}
