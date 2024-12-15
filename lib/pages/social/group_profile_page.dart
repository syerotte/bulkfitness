import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';
import '../../components/my_post_item.dart';
import '../../components/post_interaction_logic.dart';

class GroupProfilePage extends StatefulWidget {
  final String groupName;
  final String groupImage;
  final String members;
  final bool isJoined;
  final Function(bool) onJoinToggle;

  const GroupProfilePage({
    Key? key,
    required this.groupName,
    required this.groupImage,
    required this.members,
    required this.isJoined,
    required this.onJoinToggle,
  }) : super(key: key);

  @override
  _GroupProfilePageState createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  late bool isJoined;
  String _replyingTo = '';
  String _replyingToId = '';
  bool _isReplyToReply = false;

  List<Map<String, dynamic>> groupPosts = [
    {
      'username': 'John Doe',
      'content': 'Hello everyone! Excited to be part of this group!',
      'image': null,
      'likes': 15,
      'comments': [],
      'likedBy': <String>{},
    },
    {
      'username': 'Jane Smith',
      'content': 'Check out this amazing view from our last meetup!',
      'image': 'lib/images/splashscreen.png',
      'likes': 32,
      'comments': [],
      'likedBy': <String>{},
    },
    {
      'username': 'Mike Johnson',
      'content': 'Who\'s up for our next group activity this weekend?',
      'image': null,
      'likes': 8,
      'comments': [],
      'likedBy': <String>{},
    },
  ];

  @override
  void initState() {
    super.initState();
    isJoined = widget.isJoined;
  }

  void toggleJoinStatus() {
    setState(() {
      isJoined = !isJoined;
    });
    widget.onJoinToggle(isJoined);
  }

  void _showCommentsDialog(BuildContext context, List<dynamic> comments, int postIndex) {
    final TextEditingController _commentController = TextEditingController();
    _replyingTo = '';
    _replyingToId = '';
    _isReplyToReply = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 1,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          width: 40,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return PostInteractionLogic.buildCommentTile(
                                comments[index],
                                postIndex,
                                index,
                                groupPosts,
                                    (username, parentId, isReplyToReply) {
                                  setModalState(() {
                                    _replyingTo = username;
                                    _replyingToId = parentId;
                                    _isReplyToReply = isReplyToReply;
                                  });
                                },
                                setModalState,
                                    (username) {
                                  // Handle viewing user profile if needed
                                },
                              );
                            },
                          ),
                        ),
                        PostInteractionLogic.buildCommentInput(
                          postIndex,
                          groupPosts,
                          _commentController,
                          _replyingTo,
                          _replyingToId,
                          _isReplyToReply,
                          setModalState,
                              () {
                            setModalState(() {
                              _replyingTo = '';
                              _replyingToId = '';
                              _isReplyToReply = false;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        showBackButton: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.groupImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    widget.groupName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members: ${widget.members}',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Members', '1.2k'),
                      _buildStat('Posts', '${groupPosts.length}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: toggleJoinStatus,
                    child: Text(isJoined ? 'Leave Group' : 'Join Group'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isJoined ? Colors.grey : Colors.blue,
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Group Posts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupPosts.length,
                    itemBuilder: (context, index) {
                      return MyPostItem(
                        post: groupPosts[index],
                        postIndex: index,
                        onLike: () => setState(() {
                          PostInteractionLogic.toggleLike(groupPosts, index, 'currentUserId');
                        }),
                        onComment: (comment) => setState(() {
                          PostInteractionLogic.addComment(groupPosts, index, comment);
                        }),
                        onViewComments: _showCommentsDialog,
                        formatLikes: PostInteractionLogic.formatLikes,
                        onFollowToggle: () {}, // Disable follow toggle for group posts
                        onViewProfile: () {}, // Disable view profile for group posts
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

