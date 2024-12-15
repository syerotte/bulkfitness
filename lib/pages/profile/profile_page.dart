import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';
import '../../components/my_post_item.dart';
import '../../components/post_interaction_logic.dart';
import '../social/upload_post_page.dart';

class ProfilePage extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final Function(Map<String, dynamic>) onPostSubmitted;

  const ProfilePage({
    Key? key,
    required this.posts,
    required this.onPostSubmitted,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _replyingTo = '';
  String _replyingToId = '';
  bool _isReplyToReply = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetReplyingTo() {
    setState(() {
      _replyingTo = '';
      _replyingToId = '';
      _isReplyToReply = false;
    });
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
                  return GestureDetector(
                    onTap: () => _resetReplyingTo(),
                    child: Container(
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
                                  widget.posts,
                                      (username, parentId, isReplyToReply) {
                                    setModalState(() {
                                      _replyingTo = username;
                                      _replyingToId = parentId;
                                      _isReplyToReply = isReplyToReply;
                                    });
                                  },
                                  setModalState,
                                      (String username) {
                                    // Implement the logic to view the user's profile
                                    print('Viewing profile of $username');
                                  },
                                );
                              },
                            ),
                          ),
                          PostInteractionLogic.buildCommentInput(
                            postIndex,
                            widget.posts,
                            _commentController,
                            _replyingTo,
                            _replyingToId,
                            _isReplyToReply,
                            setModalState,
                            _resetReplyingTo,
                          ),
                        ],
                      ),
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
        showSettingButton: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 36.0),
                              child: const Text(
                                'dannylaid77',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: _buildStat('Posts', '${widget.posts.length}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: _buildStat('Followers', '21'),
                                ),
                                _buildStat('Following', '75'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                3,
                                    (index) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Icon(Icons.emoji_events, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '49',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[800],
                              ),
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 0.5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '65',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '8 kg gained',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Current: 57 kg',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: Colors.black,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 2.0,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Profile'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPostsTab(),
                        SingleChildScrollView(child: _buildProfileTab()),
                      ],
                    ),
                  ),
                ],
              ),
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
                onPostSubmitted: widget.onPostSubmitted,
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

  Widget _buildPostsTab() {
    if (widget.posts.isEmpty) {
      return Center(
        child: Text(
          'No posts yet',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return MyPostItem(
          post: widget.posts[index],
          postIndex: index,
          onLike: () => setState(() {
            PostInteractionLogic.toggleLike(widget.posts, index, 'currentUserId');
          }),
          onComment: (comment) => setState(() {
            PostInteractionLogic.addComment(widget.posts, index, comment);
          }),
          onViewComments: _showCommentsDialog,
          formatLikes: PostInteractionLogic.formatLikes,
          onFollowToggle: () {}, // Empty function as it's not applicable on profile page
          onViewProfile: () {}, // Empty function as it's not applicable on profile page
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildWorkoutCard('Chest', 5, Icons.fitness_center),
        _buildWorkoutCard('Legs', 1, Icons.accessibility_new),
        _buildWorkoutCard('Back', 4, Icons.sports_gymnastics),
        _buildWorkoutCard('Abs', 3, Icons.rectangle),
        _buildWorkoutCard('Arms', 5, Icons.sports_martial_arts),
        _buildWorkoutCard('Cardio', 2, Icons.favorite),
      ],
    );
  }

  Widget _buildWorkoutCard(String title, int level, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Level $level',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}