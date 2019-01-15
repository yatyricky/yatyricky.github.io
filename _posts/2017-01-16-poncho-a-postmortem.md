---
layout: post
title: PONCHO - A Postmortem
categories: [game,indie]
author: Dan Hayes
source: http://www.gamasutra.com/blogs/DanHayes/20170106/288790/PONCHO__A_Postmortem.php
---

## It’s finally over...

Hello everyone! It’s finally time, to get down to the PONCHO postmortem, where we talk about everything that went right, and everything that went wrong with the development of the game.

It’s a been a long, almost 5 year journey that has changed us forever. Now, a year after the initial release, it’s time to spill the beans on everything we’ve been through.

Before we do that, first we must say with a heavy heart that we’ve been forced to give up on the Vita port of the game. Things out of our control are stopping us from actually sending it to Playstation, and we have no choice but to cease development of it. Unfortunately, we can’t give any hard reasons for the cancellation without incurring some kind of legal penalty.

We hope we haven’t disappointed anyone too much with this news, but it is what it is. We’re truly unable to pursue it any further, and believe me, we’ve tried. With that out of the way, here we go...

## Winter 2011: It begins with a sprite

It’s 2011. Danny Hayes (me) and Jack Odell both have day jobs, but wanted to make a video game of our own. We decided to go full indie, and make something we knew would take years, and put everything we had into it, with the ambition of making something on the scale of BRAID or CAVE STORY. But we had no idea what to do. We were young, optimistic, and filled with big dreams of creating the next indie hit.

Then, one day, Jack created an interesting character design:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/Poncho-Run-Right.gif)

I instantly fell in love with this character. I was excited. We still didn’t know what kind of game we’d make, but we knew it was going to be about this guy. A platformer seemed like a good fit, so we spent some time talking about how to make it innovative and interesting compared to other Platformers.

Both Jack and I talked about retro inspirations, namely parallax sidescrollers on the Sega consoles, and how you’d see mountains and hills in the backgrounds, but you could never actually go there.

Jack suggested we could separate the game into layers and shift between them at will to achieve that idea. We then we named the robot after his red namesake and thus, PONCHO was born.

## 2012: A year of idealistic struggling

Before PONCHO, I had coded mainly for iOS and in C++. I had no idea how to use Unity, but decided it would be the best option since it had easy porting and was more accessible at the time than the Unreal engine.

Throughout 2011 and most of 2012 we went through a bunch of prototypes, re-designs and re-codings as I learned how to use the Unity engine more effectively. At this point, I did the code and level design, and Jack did the music and art. It went something like this:

* Build the game in actual 3D, using a world of 3D cubes with 2D characters to create a 2.5d effect. Realise that it doesn’t look good and start again using a 2D planed environment layered over itself hundreds of times to create the 2.5D effect we wanted.
* Redesign of PONCHO to make him more cute and iconic looking:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/Poncho-Run-Right-1-copy.gif)

* Design level art to look like this:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/Background-test.jpg)

* Start adding some cool ass characters:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/idle.gif)

It went on like that. By the end of the first year of development, we had most of a story, basic shifting gameplay and several levels with a bunch of characters and menus. But while mine and Jack’s art was passable, we wanted a real pixel pro to join the team and take over the art side of things.

## 2013: Matt joins the fray!

I posted on a bunch of pixel art sites, saying that we were looking for an artist to join our team. I had saved some money from my day job so we could afford some real talent. We got something like 50 applications, including one guy who strangely only had a portfolio of Hentai to show us, and one who’s portfolio included nothing but a single pixel art tree. Luckily there was also Matthew Weekes and he was just the best. After several months, the game looked like this:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/Screen-Shot.jpg)

Awesome. We finally had a quality game on our hands, and everything was starting to feel real. Also, in case you were wondering just how many layers and images are on the screen at any given time, have a gander at this early progress level:

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/Screen-Shot-2.jpg)

## The design issues

Designing Poncho was tough. As well as designing each level plane and making sure things like jump distances and obstacle placement was perfect like any other 2D platformer, it had to be designed so that it would work in sync with basically 2 other levels that you can move freely in between. We had to make sure that puzzles and obstacles on one layer couldn’t simply be bypassed by shifting to another layer without some thinking.

Additionally to make things more complicated for us, we wanted to make the game pseudo open world, so the player could choose to go left or right and still complete each area, with multiple paths and choices in which puzzles to tackle. So levels also had to work in a way where each plane would have to match up to the levels either side of the current one. Each “world” is made of a ring of levels, so by moving in one direction, eventually the player would be moving in circles effectively. This removed a lot of the stress of backtracking, instead of being at the end of a level and having to move all the way back from where they came, the player could take a shortcut by continuing to move in the same direction.

So, instead of working with pen and paper (which we did at first), I designed most of the levels in engine, moving things around and playing until each level felt like a cohesive whole where each layer was in sync with each other. It took a long time to get each level right.

Originally, we were gonna setup levels with varying numbers of planes, possibly going as high as 9 planes or so, but we felt that having only 3 planes would allow for a more concise and simplified design, plus it would far less development time.

After getting a feel for how to create levels we started to get creative in different ways we could use the shifting mechanic and added some cool effects:

* Obstacles and blocks that shift on a timer
* Obstacles and blocks that shift when you do
* Levels that move between 2D and 3D, merging layers on a timer (That’s the infamous Disco level)
* Levels where the view is set in 2D but the player has to think in 3D space (The great lake)
* Anti Shift fields that stop players from shifting in certain areas
* Level planes that slide horizontally and move over each other
* Machines that would merge large numbers of layers and place the player on the front on back layers (seen in the later levels)
* And more...

There were also a bunch of things we wanted to do and were in the original design, but ran out of funding before we could add them into the actual game:

* Fields that were connected to doors, if the player shifted within the field, the door would shut and the player would have to attempt the puzzle again
* Oil slick areas where the player would slide along quickly and have to time jumps and shifts
* Super layered levels, where there were several layers in a single level
* Shift fields that would throw you back if you shifted into them
* Shift fields that would throw you forward an extra layer if you shifted into them
* Small underwater areas in other levels, not just the lake
* There’s probably more, but it’s difficult to remember...

If I had to say PONCHO was inspired by any game in particular, I’d say Braid, with the emphasis being on puzzles. But, we also felt that the mechanics also worked in a twitch platforming situation, so the levels ended up being a mix of the two. We’d give the player some twitch platforming and timed jump sections, then let them relax with some more puzzle based areas.

The biggest sign of Braid’s influence on my designs is probably in the doors. We wanted to create a situation where players would have to “earn” and unlock new pathways and areas for each level by collecting keys, usually by completing puzzles and platforming sections. We went with colour coded doors in order to have some say on when they could unlock certain areas, for example in the very first forest area there are 4 doors in the back layer, and the player must collect all the keys in that level and also buy one from the merchant in order to take the secret back way into the other levels in order to unlock the SMASH ability as a reward, which in turn unlocked more areas to explore.

But in other cases, players will have to go exploring and beat certain puzzles in order to get keys and progress. Additionally, keys could be collected and doors opened in order to bypass some harder puzzles, as a reward for completing earlier puzzles. We designed it that way to make the game feel non-linear and give the player choices in each level.

Another aspect of the game, was the abilities. Originally there were going to more of them, and the idea was that they would enhance the experience, but not be a prerequisite for beating the game. They simply exist only to unlock more aspects of the game. We wanted the game to still be kind of pure and rely on the shifting mechanic, so we designed it so that the game could still be comfortably beaten without any abilities, while still making levels interesting for the players that did collect the abilities.

Additionally, instead of using a tile tool or something to create levels, I placed every single sprite by hand. That image above is before any decorative sprites like flowers or bushes are added, and there are hundreds of those in any given level. It took a very long time, but I wanted to do it that way in order to give the game a more “wild” look, as well as have absolute control on the visuals.

Suffice to say, designing a game of this kind was a much bigger undertaking compared to other games than we could have ever realised when we first started. In hindsight, we should have made the game a little more linear and less ambiguous.

## The Story and world Development

From the beginning, we knew that we wanted a beautiful post apocalyptic world. The themes of PONCHO are centred around the meaning of existence and purpose, as well as a side theme of nature vs man. But we also wanted the game to have a sentimental aspect, and for that reason I based the story slightly on Pinocchio. A robot who was once human, on a search for their maker, their father. The focus of the game was never really on story, more on gameplay, and for that reason we made the story elements fairly open and abstract, from Poncho’s dream sequences of the world ending at the start of the game to the super sad ending.

Originally, there were going to be about 3 times as many story scenes as there are currently. Unfortunately they had to be cut due to lack of funding. But we still felt we managed to get across all the themes and feelings that we were going for. It’s a shame, but still enough for some players to cry at the ending, which is more than enough for us.

For a post apocalyptic world, PONCHO is teeming with life. This was very important to me, I wanted to make the world feel alive and real. That’s why the game is filled with critters and characters who have no purpose other than to add a passive charm to every area. Would the game have played any different without them? Not really. Is the game better with the time it took to add them? Absolutely. By randomly generating moving characters all of the place, the world felt more alive.

## 2014 & the year everything got serious

In the Summer, me and Jack quit our jobs. There had been a lot of crunching at the studio I worked at in the spring, and development of PONCHO had been slow. Anyone who works in the industry knows how hard it is to come home and develop your own projects, when your day job is 60 hours a week minimum. Luckily I had saved enough money to sustain myself for awhile, and we finally went full time on the game. It was great. It was around this time that we knew we were gonna need funding in order to bring the game to the level that we wanted it, since we only had a few months of money left. It was time to do a KICKSTARTER.

We planned the campaign meticulously. Up to this point, we had done no marketing. We wanted everyone’s first look at the game to be within a couple of years of release, rather than announce it right away and then make people wait several years so they can lose interest.

We planned to do an announcement with a trailer, then spend a couple of months marketing before launching the campaign. We also wanted to take the game to EGX, the UK’s biggest games expo, around the same time the Kickstarter ended to give the campaign a big boost at the end. But EGX is expensive. So I took out a very large loan to keep us going for awhile and pay for the costs of taking the game to an expo (It was in the thousands).

Then we released this trailer and sent out a press release to about a thousand you-tubers and members of the press:

<iframe width="560" height="315" src="https://www.youtube.com/embed/nimoT5xC4PI" frameborder="0" allowfullscreen></iframe>

Between the announcement and launching the kickstarter, we sent out 3 major press releases, as well as updating our social media and blog posts several times a week. None of the major sites ever replied to us or wrote any articles, though we did get several small indie focused sites writing about the game.

Pressure was starting to build, we were all working very hard and stopped seeing friends. We stopped leaving the house. We stopped living. Nothing mattered except making this game as good as it can be. I was thousands in the hole, and I had spent all my money on it without having a job. (Looking back on it, I was an idiot, but in a way I’m glad I did it).

£22.5k was the goal we landed on for the Kickstarter. We figured it was the minimum we needed to finish off the game, I was fine with surviving instead of living for awhile to see it through. £22.5k between 3 people over 6 months is less than minimum wage, but we were prepared to do it. Only PONCHO mattered.

## Kickstarter Launch!

We launched the Kickstarter on the 2nd of September, 2014.

After a few hours of constantly refreshing the page, I finally went to bed, exhausted and feeling like we had accomplished something.

The next day, I looked at our campaign to see that we were already 15% towards our goal in one day! A bunch of youtubers had come on board and some more smaller sites posted about the kickstarter launching. So we got drunk and celebrated.

The next day, we were at 17%.

Shit.

To go from 15% in one day to only get 2% on the next was worrying. And it continued. By the time the end of the kickstarter was drawing near, we were only at about 25% of our goal. But we still had a big 4 screen booth at EGX, where thousands of people and press would see the game. We had spent weeks polishing and working on the demo we were showing, doing crazy hours. We hoped EGX would be just what we needed.

## EGX

I had been a programmer for years. I thought I knew what it was to be tired after working weeks of crunch at studios. But I had never been so tired as I was at EGX.

First off, our hearts sunk into our stomachs when we saw the booth. It was cool and all, I mean, we were at EGX with PONCHO! But, it was literally the worst placed booth in the entire complex. It was right on the outside of a main booth area, on the second floor, where footfall was at it’s lowest. On the other side of the partition there were hundreds of people. On our side were people who might catch a glimpse of the game as they passed to make their way to the toilet we were next to. Yes, we were next to a goddamn toilet.

I was furious, after spending just as much money as everyone else, we got far less value. To top it off, our booth alone was dark and had no lighting. In order to get press to play the game, we literally had to go out into the expo and grab as much press as we could and lead them to our own booth, because no one knew where it was. Additionally, due to the lighting situation, some press that wanted to conduct interviews couldn’t do it in front of our booth because it was too dark. That’s how bad it was.

Still, there were usually a couple of seats filled most of the time, if someone stumbled across our darkened area of EGX. We did a bunch of interviews, and energetically tried to “sell” the game to as many people as possible. It was tiring, but still an amazing experience to see people finally playing the game.

Until we realised there was a crash bug in our demo, which required us to get out a keyboard to reboot the game. It was awful, it was just like that scene from “Indie game: the movie” where Phil Fish is rebooting FEZ at PAX because the build keeps crashing. It was exactly like that, complete with us apologising and being like: “You can try again from the beginning if you want...”. About 75% of people never got it though, so it wasn’t too bad.

After the first day, our legs felt like blocks of numbed wood, our throats was sore as hell, and it was also the day I took up smoking. There were 3 days left. Oh god.

Each day went on much like the rest, with us watching in wonder and joy as people played the game, at the same time as being saddened that we were somewhat ignored compared to the other booths. One interesting moment is when a journalist from Destructoid sat down to play the game one day. The guy played through the whole thing with a smile on his face and writing down things in his notepad every now and then.

We started to notice something at this point after seeing so many people play the game.

PONCHO is marmite. You either like it, or you hate it. While some players put the controller down after 5 minutes, the guy from Destructoid seemed to like it, and wrote a nice article urging others to kickstart us.  It was the first time a major outlet had given us an article and it was amazing.

But my favourite memory is of a young girl, maybe 7 years old, constantly dragging her parents back to the PONCHO booth so she could play it more. It was her favourite. I almost felt like crying, that single thing is probably my favourite memory of all the Poncho years. It made all the stress seem worth it, if only for moment.

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/photo.jpg)

*From left to right, Matt, Jack and me, at the Rezzed expo. We got a better space that time! ^\_^*

## Failure & funding

Well, I’m sure you can guess, but the Kickstarter failed. In the end we only got to 38% of our goal. This, was the turning point from optimistic game development, into a terrible, sinking, depressive state for all of us. We had no money. I was literally down to under £100 after EGX, we were banking everything on the publicity of the expo making the kickstarter a success. It did give a bit of a boost, but it wasn’t enough. It was all over, we were gonna have to go back to our day jobs and put PONCHO on hold, after all that sacrifice and effort.

But then something wonderful happened.

Suddenly, we got an email from a publisher asking to fund us. And then another publisher. And then another. It seemed that taking PONCHO to EGX had been a success after all! After negotiating through all our options, we landed on Rising Star Games, mainly because they were in the same country and seemed to know what they were doing with indies. I also thought they seemed like nice people at the time. We got funded for slightly less than what we asked for in our kickstarter, but we were funded. We did have much higher offers, but turned them down since other publishers asked if they could change the game.

## 2015 & the year where everything broke down

Now, this is where writing this gets tough. For legal reasons, there’s a bunch of events here that we can’t talk about. There would be massive repercussions if we do, and we’ve been told as much. I would, however, suggest this to all you other developers out there: Think very, very, very hard about whether or not getting a publisher is right for you.

Due to these events, we had no money, I lost my home, we lost our sony dev kits, I was thousands in debt and we had to cut a great deal of the designed content from PONCHO, including key characters and story elements in order to release something at least. And no one would help us.

In a sense, what we released was not the full game, especially the PS4 version which was taken away and finished by another company. We were never even able to test the PS4 version before it was released either, later finding out changes had been made that we didn’t want and it was full of bugs. We even had to cut the reward for collecting all of the junkyard king’s minions, which was gonna give the player a bonus end credits scene. I took out more loans just to survive and finish the steam version of the game, as we were not able to attempt to try and secure funding elsewhere. I started to smoke cannabis in order to just kinda cope with things. But, after months of pain, stress and general depression, we hit a release date.

![Fig](http://plb5hiaqr.bkt.clouddn.com/poncho-a-postmortem/ponchodevtime.jpg)

## 2016 & the worst year of my life

<iframe width="560" height="315" src="https://www.youtube.com/embed/cB4TWcKLCI0" frameborder="0" allowfullscreen></iframe>

PONCHO was released on PS4 and STEAM on November 3rd 2015. After seeing the sales, we celebrated the release by writing out our CVs to start looking for a day job. It wasn’t nearly as much as we were expecting, even by a pessimistic standard. It was truly awful.

Steam made me furious, upon releasing, we were in the new releases tab on the front page for about 3 hours, and then the game could only be found by searching for it or by it possibly turning up in someone’s recommendations. Slightly older games that had released earlier that day remained in that tab for days, and despite having a 90% review rating at the time, it seemed we weren’t selling enough copies in those few hours for steam to keep it on the front page. The Steam store isn’t much better than the Apple App store these days it seems.

Also, the reviews were confusing. We have a metacritic score of about 65, but only based on 4 reviews. There are, in fact, over 50 reviews on the web, and the average is about 7/10. Not bad for a first game! But they were all over the place. Some reviews gave it a 5/10, citing it was too hard. Others, gave it 5/10 citing that it was too easy. Others gave it an 8 or 9/10 saying it was great. We didn’t really know what to think. But we did learn a lot. Maybe the reviews just went that way because of the game’s marmite feel. It’s worth noting that, despite having a publisher on board, none of the really big sites like Kotaku, PC gamer, IGN, Rock Paper Shotgun, etc, ever covered our game. Destructoid only covered us after we got in contact with them ourselves. So don’t think that having a publisher handling the marketing will make a difference when it comes to press actually replying to emails.

**On the date of writing this, over a year after releasing on multiple platforms, Delve Interactive has not yet made a single penny from PONCHO.**

It feels horrible to write that down, but there it is. We still have all the debt as well as painful/wonderful memories and experiences though. A year after the initial release, we released the Wii U version which had similar result as the first one. We’ve since developed patches for the Wii U and PS4 versions while working new day jobs, but we have been prevented from actually handing them over to the platforms.

Forgetting the political and celebrity deaths aspects of 2016, it has been one of the saddest years of our lives. All that time. All that money. All that sacrifice. Nothing in return but huge debts. Money was never important to us, but we hoped to at least have enough to spend on another game full time. We pretty much stopped writing updates and social media posts, it was too depressing to think about. I had trouble holding jobs after going through a series of mental breakdowns.

It’s taken a whole year, but I’m finally starting to feel better and leaving the house more at least.

Now the part you’ve been waiting for, what advice can we give to other developers... here are the key things we learned while making PONCHO.

* DO NOT QUIT YOUR DAY JOB.
* Design something that’s simple, you can still make a big game, but make sure the design is concise.
* If you ever get this feeling: “Meh, it’s good enough, let’s just release and be done with this hell”. Wait. You will regret it, even if you’re on the brink of homelessness and need money, suffer through it and wait. It will be worth it.
* You probably won’t make much money. Don’t risk your finances for years by going into debt and putting all your chips in.
* DO NOT RELEASE IN NOVEMBER.
* Publishers aren’t always going to magically get people talking about your game. If that’s the reason you have for getting one, don’t.
* Porting from PC to console is not the same as porting from PC to Mac or mobile in Unity. It’s a lot of work.
* Game expos and watching other people play your game is key to making your game better, as well as making you a better designer.
* DO NOT DO GIVEAWAYS. You’ll get emails all the time from people saying they’ll market your game by giving it away. Even if you’ve only sold a few hundred copies, it’s not worth it. It won’t benefit anyone but the person doing the giveaway.
* If you do a kickstarter video, make sure it has you, the developers, in the video.
* DO NOT GIVE KEYS TO YOUTUBERS WITH LOADS OF SUBSCRIBERS WHO REQUEST IT. If you get a request from a you tuber who has a million subscribers, that should raise a red flag. Popular youtubers do not request keys. If you give them a key, your game will be all over torrent and pirate sites within a week.
* Getting on board with consoles is much easier than you might think. It literally takes a few emails usually to get access to dev kits and software to develop for consoles if you have a good game.

## In closing...

This is not the end.

We’ve learned so much and we still have so many ideas, so we’ll never stop making games. Was PONCHO worth it? Yes. We released a game on steam and consoles, something we always dreamed of. And we have to cut ourselves some slack, it’s only our first try at this; we have our whole lives ahead of us.

On that note, we would like to announce our next game. Please, enjoy, and from all of us at Delve Interactive, peace out. ^\_^