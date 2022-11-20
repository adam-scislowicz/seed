# Summon

This folder is used when I want to bring something back into my working memory. The word summon is being used in that context here. So I use this to maintain balance within my working memory and other subsystems with hysteresis, internal and external.

I will maintain a list of thigs that I am balancing here.

1. Personal
    1. Use timecamp for now and see how it goes
    5. Can I apply tags to files to aid in later searchability. Can it be done in a way such that an automated tool can rename tags later as part of an interactive refactoring process.
2. Extropic Networks
    1. eSymbiote device
    2. cloud-side supporting systems
        1. Add observability support for your cloud resources (e.g. prometheus/grafana)
        2. Add alerts and spending caps to your cloud resources (e.g. alerts generate emails)
3. Amazon
    1. On-Target SMP Test Framework
        1. addition of the scheduler trace log and supporting analysis routines in the BSL
    2. Anki cards for the FreeRTOS kernel
4. Skill Development
    1. CI/CD With simulation based validation. Align this with physics first. Later integrate with physical chemistry and then biophysics. Practically these are jupyter notebooks and supporting resources. The intent is to prototype the multi-model integration marketplace or hub.

## eSymbiote

The eSymbiote is an inexpensive (~100$) device that gives you a secure identity with pseudonym generation along with the following initial features:

1. secure encrypted tunnel from the edge to major cloud vendors. (e.g. VPN)
2. secure storage for small amounts of data such as login credentials, etc. along with cloud-side infrastructure so that you can use those to automate cloud processes. You can also opt-out of a feature which will allow you to restore this even if your device is damaged. In that case you will be trusting extropic networks to keep an encryption key which can be used, only if you approve it, for recovery. Different keys will be generated for each individual, there is no skeleton key, and distribution will not enter the public internet infrastructure. These will be kept in a private facility and every use will be logged.
3. secure psuedoanonymous messaging to other extropic networks users
4. next-generation locale aware, moderated, non-real-time forum system. Yes that is a lot of qualifying words, but I think this will become central to how communities self-organize and maintain extropic interaction in the future.

### Psuedonym Generation

While you have one secure digital identity with extropic networks, you will never use that directly when interacting with others. You will always use a psuedonym or handle. This is to protect you from hyper-lateralization or over politization which occurs on the internet due to its scale and lack of regulation. Furthermore location aware features will allow you to discover people who are nearby in the community along with having a means of communicating and interacting generatively with them.

### Forums & Moderation

Later I think we will have an AI based system, that detects abusive or the subtle manipulative use of language. This will be used to provide input to channel moderators. Anyone can create a channel or topic, these will have a location aware component used when searching for channels or topics in order to optimize for physical practicality. Non-local communications are also possible, and each channel will have a moderator and moderators will have access to signals from the machine learning based systems which attempt to detect and label/annotate language abuse or misuse. The system intentionally avoids real-time communications, and instead focuses on slower, higher quality interaction. So for moderated channels, content will not appear until the moderator approves. Again you can always create your own channel if you want to maintain a channel with different dynamics. The idea is that this system is a compliment to reality, e.g. if you want to do things in real time then you can meet in person, make a phone call, or have a video conference. This is intentionally different, and it is desgined to promote extropy, having learned from all of the platforms that I have utilised thus far.

Furthermore, the AI system which detects and labels language will co-exist with moderator training, which is a continuous process. Maintaining moderator status will require one to maintain credentials with an education system. I do not expect this to be a burden, but it is critical to maintaining awareness of how to interpret the labeled data coming from the AI, and also to keep up to date with the folksonomics of the channel being moderated. An AI system will help to prepare this content. All AI generated learning materials will be clearly marked as such. AIs will be named, and you will know which AI you are receiving content from. That way if you have feedback regarding the content, it can be properly routed to those who work on that instance AI.

