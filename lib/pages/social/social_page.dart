import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';
import '../../components/my_chat_preview.dart';
import '../../components/my_chat_screen.dart';
import '../../components/my_group_suggestion.dart';
import '../../components/my_post_item.dart';
import '../../components/my_user_suggestion.dart';
import '../../components/post_interaction_logic.dart';
import 'upload_post_page.dart';
import 'user_profile_page.dart';
import 'group_profile_page.dart';

class SocialPage extends StatefulWidget {
  final List<Map<String, dynamic>> sharedPosts;
  final Function(Map<String, dynamic>) onPostSubmitted;

  const SocialPage({
    Key? key,
    required this.sharedPosts,
    required this.onPostSubmitted,
  }) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> discoverPosts = [
    {
      'username': 'Aubrey Drake Graham',
      'description': 'Big Guns',
      'comments': [
        {
          'id': '4',
          'username': 'Fan123',
          'text': 'Looking strong, Drake!',
          'likes': 10,
          'likedBy': <String>{'user1', 'user2'},
          'replies': []
        },
      ],
      'likes': 1000,
      'likedBy': <String>{},
      'image': 'lib/images/splashscreen.png',
      'isFollowing': false,
    },
    {
      'username': 'Taylor Swift',
      'description': 'New album coming soon!',
      'comments': [],
      'likes': 5000,
      'likedBy': <String>{},
      'image': 'lib/images/apple.png',
      'isFollowing': false,
    },
    {
      'username': 'Cristiano Ronaldo',
      'description': 'Training day',
      'comments': [],
      'likes': 3000,
      'likedBy': <String>{},
      'image': 'lib/images/intermediate.jpeg',
      'isFollowing': false,
    },
    {
      'username': 'Elon Musk',
      'description': 'To the moon!',
      'comments': [],
      'likes': 2000,
      'likedBy': <String>{},
      'image': 'lib/images/beginner.jpg',
      'isFollowing': false,
    },
  ];

  final List<Map<String, dynamic>> groups = [
    {
      'name': 'Alpha Sigma',
      'members': 'Ahmad Syerot, 2k others',
      'image': 'lib/images/beginner.jpg',
      'isJoined': false,
    },
    {
      'name': 'Mike N',
      'members': 'Drizzle, 1.2k others',
      'image': 'lib/images/intermediate.jpeg',
      'isJoined': false,
    },
  ];

  Map<String, Map<String, dynamic>> chatData = {
    'Kanye East': {
      'messages': [
        {'sender': 'Kanye East', 'text': 'Yo bro, when are we going to get a sesh together', 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 1)),
    },
    'Ahmad Syerot': {
      'messages': [
        {'sender': 'Ahmad Syerot', 'text': 'weh kau tertinggal kunci Porsche dalam beg aku ni ha', 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 2)),
    },
    'Kloppo': {
      'messages': [
        {'sender': 'Kloppo', 'text': "I'm running out of energy", 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 3)),
    },
    'Chris Bumstead': {
      'messages': [
        {'sender': 'Chris Bumstead', 'text': 'You will never get big like me bro if u keep skipping gym', 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 4)),
    },
    'Zizan Razak': {
      'messages': [
        {'sender': 'Zizan Razak', 'text': 'otw', 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 5)),
    },
    'AC Mizal': {
      'messages': [
        {'sender': 'AC Mizal', 'text': 'peace yo!', 'isMe': false},
      ],
      'unreadCount': 1,
      'lastOpened': DateTime.now().subtract(Duration(days: 6)),
    },
  };

  String _replyingTo = '';
  String _replyingToId = '';
  bool _isReplyToReply = false;

  Set<String> following = {};
  Set<String> joinedGroups = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void addNewPost(Map<String, dynamic> newPost) {
    setState(() {
      widget.sharedPosts.insert(0, newPost);
    });
  }

  void updateLastMessage(String username, String message) {
    setState(() {
      chatData[username]!['messages'].add({'sender': 'Me', 'text': message, 'isMe': true});
      chatData[username]!['unreadCount'] = 0;
      chatData[username]!['lastOpened'] = DateTime.now();
      final updatedChat = chatData.remove(username)!;
      chatData = {username: updatedChat, ...chatData};
    });
  }

  int getTotalUnreadMessages() {
    return chatData.values.fold(0, (sum, chat) => sum + (chat['unreadCount'] as int));
  }

  void _showCommentsDialog(BuildContext context, List<dynamic> comments, int postIndex, {bool isDiscoverPost = false}) {
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
                                isDiscoverPost ? discoverPosts : getFollowingPosts(),
                                    (username, parentId, isReplyToReply) {
                                  setModalState(() {
                                    _replyingTo = username;
                                    _replyingToId = parentId;
                                    _isReplyToReply = isReplyToReply;
                                  });
                                },
                                setModalState,
                                _viewUserProfile,
                              );
                            },
                          ),
                        ),
                        PostInteractionLogic.buildCommentInput(
                          postIndex,
                          isDiscoverPost ? discoverPosts : getFollowingPosts(),
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

  void _updateFollowState(String username, bool isFollowing) {
    setState(() {
      final discoverIndex = discoverPosts.indexWhere((post) => post['username'] == username);
      if (discoverIndex != -1) {
        discoverPosts[discoverIndex]['isFollowing'] = isFollowing;
      }

      for (var post in widget.sharedPosts) {
        if (post['username'] == username) {
          post['isFollowing'] = isFollowing;
        }
      }

      if (isFollowing) {
        following.add(username);
      } else {
        following.remove(username);
      }
    });
  }

  void _toggleFollowUser(String username) {
    final isCurrentlyFollowing = following.contains(username) ||
        discoverPosts.any((post) => post['username'] == username && post['isFollowing'] == true);
    _updateFollowState(username, !isCurrentlyFollowing);
  }

  void _viewUserProfile(String username) {
    final List<Map<String, dynamic>> posts =
    [...widget.sharedPosts, ...discoverPosts].where((post) => post['username'] == username).toList();

    final isFollowing = following.contains(username) ||
        posts.any((post) => post['isFollowing'] == true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          username: username,
          posts: posts,
          isFollowing: isFollowing,
          onFollowToggle: () => _toggleFollowUser(username),
          onMessageSent: updateLastMessage,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getFollowingPosts() {
    return [
      ...widget.sharedPosts,
      ...discoverPosts.where((post) => following.contains(post['username']) || post['isFollowing'] == true)
    ];
  }

  Widget _buildFollowingTab() {
    final followingPosts = getFollowingPosts();
    return ListView.builder(
      itemCount: followingPosts.length,
      itemBuilder: (context, index) {
        return MyPostItem(
          post: followingPosts[index],
          postIndex: index,
          onLike: () => setState(() {
            PostInteractionLogic.toggleLike(followingPosts, index, 'currentUserId');
          }),
          onComment: (comment) => setState(() {
            PostInteractionLogic.addComment(followingPosts, index, comment);
          }),
          onViewComments: (context, comments, index) => _showCommentsDialog(context, comments, index),
          formatLikes: PostInteractionLogic.formatLikes,
          onFollowToggle: () => _toggleFollowUser(followingPosts[index]['username']),
          onViewProfile: () => _viewUserProfile(followingPosts[index]['username']),
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => MyPostItem(
              post: discoverPosts[index],
              isDiscoverPost: true,
              postIndex: index,
              onLike: () => setState(() {
                PostInteractionLogic.toggleLike(discoverPosts, index, 'currentUserId');
              }),
              onComment: (comment) => setState(() {
                PostInteractionLogic.addComment(discoverPosts, index, comment);
              }),
              onViewComments: (context, comments, index) => _showCommentsDialog(context, comments, index, isDiscoverPost: true),
              formatLikes: PostInteractionLogic.formatLikes,
              onFollowToggle: () => _toggleFollowUser(discoverPosts[index]['username']),
              onViewProfile: () => _viewUserProfile(discoverPosts[index]['username']),
            ),
            childCount: discoverPosts.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Suggested Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                final user = 'User${index + 1}';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MyUserSuggestion(
                    username: user,
                    isFollowing: following.contains(user),
                    onFollowToggle: () => _toggleFollowUser(user),
                    onViewProfile: () => _viewUserProfile(user),
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Suggested Groups',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupProfilePage(
                          groupName: groups[index]['name'],
                          groupImage: groups[index]['image'],
                          members: groups[index]['members'],
                          isJoined: groups[index]['isJoined'],
                          onJoinToggle: (bool newJoinStatus) {
                            setState(() {
                              groups[index]['isJoined'] = newJoinStatus;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: MyGroupSuggestion(
                    group: groups[index],
                    onJoin: () {
                      setState(() {
                        groups[index]['isJoined'] = !groups[index]['isJoined'];
                      });
                    },
                    isJoined: groups[index]['isJoined'],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsTab() {
    return ListView.builder(
      itemCount: chatData.length,
      itemBuilder: (context, index) {
        final username = chatData.keys.elementAt(index);
        final chat = chatData[username]!;
        final messages = chat['messages'] as List<Map<String, dynamic>>;
        final lastMessage = messages.last;
        final unreadCount = chat['unreadCount'] as int;
        final lastOpened = chat['lastOpened'] as DateTime;
        return MyChatPreview(
          chat: {
            'username': username,
            'lastMessage': lastMessage['text'] as String,
            'isLastMessageMine': lastMessage['isMe'] as bool,
            'unreadCount': unreadCount,
            'lastOpened': lastOpened,
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyChatScreen(
                  username: username,
                  onMessageSent: updateLastMessage,
                  initialMessages: messages,
                ),
              ),
            ).then((_) {
              setState(() {
                chatData[username]!['unreadCount'] = 0;
                chatData[username]!['lastOpened'] = DateTime.now();
              });
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalUnreadMessages = getTotalUnreadMessages();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppbar(),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Following'),
              Tab(text: 'Discover'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Friends'),
                    if (totalUnreadMessages > 0)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          totalUnreadMessages.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFollowingTab(),
                _buildDiscoverTab(),
                _buildFriendsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPostPage(
                onPostSubmitted: addNewPost,
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

