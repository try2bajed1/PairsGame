    package {

    import com.greensock.TweenLite;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    public class Game extends MovieClip{

        public static var COLUMNS:uint = 6;
        private static const INCORRECT_ATTEMPTS:uint = 15;

        private var typesEnumVec:Vector.<uint>;
        private var mixedPairsVec:Vector.<uint>;

        private var cardsFieldMC:MovieClip;
        private var winMC:WinMc;
        private var looseMC:LooseMc;

        private var cardsMcVec:Vector.<Card>;
        private var firstCard:Card;
        private var secondCard:Card;

        private var openCardSnd:Sound;
        private var missSnd:Sound;
        private var matchSnd:Sound;
        private var winSnd:Sound;
        private var looseSnd:Sound;

        private var sndChannel:SoundChannel;
        private var sndTransf:SoundTransform;

        private var incorrectSelectionCounter ;



        public function Game() {

            super();

            typesEnumVec = Card.typesEnumVec; //Vector.<uint>([TYPE_PHONE_1, TYPE_PHONE_2, TYPE_PHONE_3, TYPE_PHONE_4, TYPE_PHONE_5,TYPE_PHONE_6, TYPE_PHONE_7, TYPE_PHONE_8, TYPE_PHONE_9 ]);
            cardsMcVec = new Vector.<Card>();

            initGUI();
            initSounds();

//            refreshGame();

            addEventListener(Event.ADDED_TO_STAGE, alignContainers);
        }



        private function initGUI():void {
            cardsFieldMC = new MovieClip();
            addChild(cardsFieldMC);

            winMC = new WinMc();
            winMC.visible = false;
            winMC.getChildByName("playAgain").addEventListener(MouseEvent.CLICK, playAgain);
            addChild(winMC);

            looseMC = new LooseMc();
            looseMC.visible = false;
            looseMC.getChildByName("playAgain").addEventListener(MouseEvent.CLICK, playAgain);
            addChild(looseMC);

            var footer:Footer = new Footer();
            footer.y = 625;
            addChild(footer);
        }


        private function initSounds():void {

            sndChannel = new SoundChannel();
            sndTransf = new SoundTransform();
            sndChannel.soundTransform = sndTransf;

            openCardSnd = new OpenCard();
            missSnd = new Miss();
            matchSnd = new Match();
            winSnd = new WinSnd();
            looseSnd = new LooseSnd();
        }



        private function alignContainers(e:Event):void {

            winMC.x = Math.floor((stage.stageWidth - winMC.width)/2);
            winMC.y = 50;

            looseMC.x = Math.floor((stage.stageWidth - looseMC.width)/2);
            looseMC.y = 50;
        }



        private function initMixedPairsVec():void {

            if(mixedPairsVec!=null && mixedPairsVec.length>0) {
                mixedPairsVec = null;
            }
            mixedPairsVec = typesEnumVec.concat(typesEnumVec);

            // mix elements
            var cardsLen:uint = mixedPairsVec.length;
            for (var i:uint = 0; i<100; i++) {
                var swap1:int = Math.floor(Math.random()*cardsLen);
                var swap2:int = Math.floor(Math.random()*cardsLen);
                var tempValue:int = mixedPairsVec[swap1];
                mixedPairsVec[swap1] = mixedPairsVec[swap2];
                mixedPairsVec[swap2] = tempValue;
            }
        }


        private function initCards():void {

            var animAppearanceDelta:uint = 50;
            var dropShadow:DropShadowFilter = getShadowFilter();

            if(cardsMcVec.length>0) {    // if player looses the game some cards are still exist, so remove them
                cardsMcVec = null;
                cardsMcVec =  new Vector.<Card>();
                cardsFieldMC.removeChildren();
            }

            var cardsLen:uint = mixedPairsVec.length;
            for (var i:uint = 0; i < cardsLen; i++) {
                var card:Card = new Card(mixedPairsVec[i]);
                card.x = 25 + 160 * (i % COLUMNS) + animAppearanceDelta;
                card.y = 30 + 200 * Math.floor(i / COLUMNS) ;
                card.alpha = 0;
                card.filters = new Array(dropShadow);
                card.buttonMode = true;
                cardsFieldMC.addChild(card);
                cardsMcVec.push(card);

                TweenLite.to(card, 0.5, {delay: 0.1 * i, alpha: 1, x: card.x-animAppearanceDelta, onComplete: setListenerOnCard, onCompleteParams: [card]});
            }
        }



        private function setListenerOnCard(card:Card):void{
            card.addEventListener(MouseEvent.CLICK, onCardClick, false, 0, true);
        }



        public function refreshGame():void {

            incorrectSelectionCounter = INCORRECT_ATTEMPTS;

            initMixedPairsVec();
            initCards();
        }



        private function playAgain(event:MouseEvent):void {
            event.currentTarget.parent.visible = false;
            cardsFieldMC.visible = true;
            refreshGame();
        }



        private function onCardClick(e:MouseEvent):void {

            if (firstCard == null){

                firstCard = e.currentTarget as Card;
                firstCard.open();

                sndChannel = openCardSnd.play();

            } else if (secondCard == null) {

                       if (firstCard == e.currentTarget as Card) return;

                        secondCard = e.currentTarget as Card;
                        secondCard.open();

                        if(firstCard.type == secondCard.type) {
                            sndChannel = matchSnd.play();
                            removePair();
                            if(mixedPairsVec.length == 0) {
                                cardsFieldMC.visible = false;
                                winMC.visible = true;
                                sndChannel = winSnd.play();
                            }
                        }  else {
                            sndChannel = missSnd.play();
                            incorrectSelectionCounter--;
                            if(incorrectSelectionCounter == 0) { // если исчерпал все попытки, то заканчиваем игру, показывая скрин лузера
                                cardsFieldMC.visible = false;
                                looseMC.visible = true;
                                sndChannel = looseSnd.play();
                            }
                        }

                   } else {
                        //this is the third card clicked, means the cards clicked do not match. reset them

                        firstCard.close();
                        secondCard.close();

                        secondCard = null;

                        firstCard = e.currentTarget as Card;
                        firstCard.open();

                        sndChannel = openCardSnd.play();
                    }
        }



        private function removePair():void {

            firstCard.removeEventListener(MouseEvent.CLICK, onCardClick);
            secondCard.removeEventListener(MouseEvent.CLICK, onCardClick);

//            TweenLite.to(firstCard,  0.5, {alpha: 0, delay:1, onComplete: removeCard, onCompleteParams: [firstCard]});
//            TweenLite.to(secondCard, 0.5, {alpha: 0, delay:1, onComplete: removeCard, onCompleteParams: [secondCard]});

            TweenLite.to(firstCard,  0.5, {y:"-30", alpha: 0, delay:1, visible:false});
            TweenLite.to(secondCard, 0.5, {y:"-30", alpha: 0, delay:1, visible:false});

            var firstIndex:int = mixedPairsVec.indexOf(firstCard.type);
            mixedPairsVec.splice(firstIndex, 1);
            cardsMcVec.splice(firstIndex, 1);

            var secondIndex:int = mixedPairsVec.indexOf(secondCard.type);
            mixedPairsVec.splice(secondIndex ,1);
            cardsMcVec.splice(secondIndex, 1);

            firstCard = null;
            secondCard = null;

        }



        private function removeCard(mc:MovieClip):void {
            //cardsFieldMC.removeChild(mc);
            mc.visible = false;
        }



        private static function getShadowFilter():DropShadowFilter {
            var dropShadow:DropShadowFilter = new DropShadowFilter();
            dropShadow.distance = 5;
            dropShadow.angle = 60;
            dropShadow.color = 0x666666;
            dropShadow.alpha = 1;
            dropShadow.blurX = 2;
            dropShadow.blurY = 8;
            dropShadow.strength = 1;
            dropShadow.quality = 15;
            dropShadow.inner = false;
            dropShadow.knockout = false;
            dropShadow.hideObject = false;
            return dropShadow;
        }






        private function showArr():void{
            for(var i:int=0; i<mixedPairsVec.length;i++) {
                trace(mixedPairsVec.length+" "+ mixedPairsVec[i])
            }
        }



        }

    }
