import VPlay 2.0
import QtQuick 2.0

EntityBase {
  id: fishElement
  width: spriteFish.width
  height: spriteFish.height

  property int variationDistance: 70
  property double delay: 0

  opacity: calculateOpacity()

  MultiResolutionImage {
    id: spriteFish
    y: scene.height/2
    source: "../../assets/img/fishSprite.png"
  }

  Item{
  clip:true
  width:spriteFish.width
  height:spriteFish.height
  y: scene.height/2
  }

  BoxCollider {
    id: collider
    width: spriteFish.width
    height: spriteFish.height
    anchors.centerIn: spriteFish
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
    minPropertyValue: scene.gameWindowAnchorItem.x-fishElement.width*1.5
    onLimitReached: {
      reset()
  }
  }

  function calculateOpacity() {
      return player.calculateOpacity(fishElement.x)
  }

  function generateRandomValueBetween(minimum, maximum) {
    return Math.random()*(maximum-minimum) + minimum
  }

  function reset() {
    fishElement.x = scene.gameWindowAnchorItem.width+fishElement.width/2
    fishElement.y = generateRandomValueBetween(-variationDistance, variationDistance)-scene.height/3
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
