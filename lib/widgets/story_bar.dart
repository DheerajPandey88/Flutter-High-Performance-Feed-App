import 'package:flutter/material.dart';

class StoryBar extends StatelessWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 10,
        itemBuilder: (_, i) {
          final isMe = i == 0;

          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Stack(
                  children: [
                    /// STORY RING
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isMe
                            ? null
                            : const LinearGradient(
                                colors: [Colors.pink, Colors.orange],
                              ),
                        color: isMe
                            ? Colors.grey.shade300
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=$i",
                          ),
                        ),
                      ),
                    ),

                    /// ADD BUTTON (Your Story)
                    if (isMe)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                /// USERNAME
                Text(
                  isMe ? "Your Story" : "user$i",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}