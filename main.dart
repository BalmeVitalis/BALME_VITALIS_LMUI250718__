
import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const HomeScreen(),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool completed;
  String priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
    required this.priority,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Task> tasks = [
    Task(
      title: 'Complete Flutter Assignment',
      description: 'Finish the personal task management application.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'High',
    ),
    Task(
      title: 'Study UI Design',
      description: 'Learn modern Flutter UI principles.',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: 'Medium',
    ),
    Task(
      title: 'Read Documentation',
      description: 'Read Flutter state management documentation.',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: 'Low',
    ),
  ];

  String filter = 'All';
  bool ascending = true;

  List<Task> get filteredTasks {
    List<Task> filteredList = tasks;

    if (filter == 'Completed') {
      filteredList = tasks.where((task) => task.completed).toList();
    } else if (filter == 'Pending') {
      filteredList = tasks.where((task) => !task.completed).toList();
    }

    filteredList.sort((a, b) {
      return ascending
          ? a.dueDate.compareTo(b.dueDate)
          : b.dueDate.compareTo(a.dueDate);
    });

    return filteredList;
  }

  void addTask() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: priority,
                      items: ['High', 'Medium', 'Low']
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          priority = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        tasks.add(
                          Task(
                            title: titleController.text,
                            description: descriptionController.text,
                            dueDate: DateTime.now()
                                .add(const Duration(days: 2)),
                            priority: priority,
                          ),
                        );
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/300',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Balme Mamoudu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Flutter Developer & Computer Science Student',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          buildProfileCard(Icons.email, 'Email', 'balme@example.com'),
          buildProfileCard(Icons.phone, 'Phone', '+237 670 000 000'),
          buildProfileCard(Icons.location_on, 'Location', 'Buea, Cameroon'),
          buildProfileCard(Icons.school, 'University', 'University Student'),
        ],
      ),
    );
  }

  Widget buildProfileCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget buildStatisticsBar() {
    int total = tasks.length;
    int completed = tasks.where((task) => task.completed).length;
    int pending = total - completed;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          statisticItem('Total', total.toString()),
          statisticItem('Completed', completed.toString()),
          statisticItem('Pending', pending.toString()),
        ],
      ),
    );
  }

  Widget statisticItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget buildTaskListScreen() {
    return Column(
      children: [
        buildStatisticsBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: filter,
                  decoration: const InputDecoration(
                    labelText: 'Filter Tasks',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', 'Completed', 'Pending']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      filter = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  setState(() {
                    ascending = !ascending;
                  });
                },
                icon: Icon(
                  ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      setState(() {
                        task.completed = value!;
                      });
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    'Priority: ${task.priority}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailScreen(task: task),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentIndex == 0 ? 'Profile' : 'Task Manager',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications Clicked'),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings Clicked'),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: currentIndex == 0
          ? buildProfileScreen()
          : buildTaskListScreen(),
      floatingActionButton: currentIndex == 1
          ? FloatingActionButton(
              onPressed: addTask,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  Color getPriorityColor() {
    switch (task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.description),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(task.description),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(
                      task.dueDate.toString().split(' ')[0],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.flag),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getPriorityColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.priority,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.check_circle),
                    const SizedBox(width: 10),
                    Text(
                      task.completed
                          ? 'Completed'
                          : 'Pending',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: task.completed
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
