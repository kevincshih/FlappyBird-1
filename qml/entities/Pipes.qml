import VPlay 2.0
import QtQuick 2.0

EntityBase {
  id: pipeElement
  width: spriteUpperPipe.width
  height: spriteUpperPipe.height+pipeGateway+spriteBottomPipe.height

  property int pipeGateway: 90
  property int variationDistance: 70
  property double delay: 0

  opacity: calculateOpacity()

  MultiResolutionImage {
    id: spriteUpperPipe
    source: "../../assets/img/pipe_green.png"
    mirrorY: true
  }

  MultiResolutionImage {
    id: spriteBottomPipe
    y: height+pipeGateway
    source: "../../assets/img/pipe_green.png"
  }


  Item{
  clip:true
  width:spriteUpperPipe.width
  height:pipeGateway
  y: spriteUpperPipe.height

  }
  BoxCollider {
    id: collider
    width: spriteUpperPipe.width
    height: spriteUpperPipe.height
    anchors.centerIn: spriteUpperPipe
    bodyType: Body.Static
    collisionTestingOnlyMode: true
    fixture.onBeginContact: {
      player.gameOver()
    }
  }

  BoxCollider {
    width: 10
    height: pipeGateway
    y: spriteBottomPipe.height
    x: spriteBottomPipe.width/2
    bodyType: Body.Static
    collisionTestingOnlyMode: true
    fixture.onBeginContact: {
      gameScene.score++

      audioManager.play(audioManager.idPOINT)
    }
  }

  BoxCollider {
    id: colliderBottomPipe
    width: spriteBottomPipe.width
    height: spriteBottomPipe.height
    anchors.centerIn: spriteBottomPipe
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
    minPropertyValue: scene.gameWindowAnchorItem.x-pipeElement.width*1.5
    onLimitReached: {
      reset()
    }
  }

  function calculateOpacity() {
      return player.calculateOpacity(pipeElement.x)
  }

  function generateRandomValueBetween(minimum, maximum) {
    return Math.random()*(maximum-minimum) + minimum
  }

  function reset() {
    pipeElement.x = scene.gameWindowAnchorItem.width+pipeElement.width/2
    pipeElement.y = generateRandomValueBetween(-variationDistance, variationDistance)-scene.height/3
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
