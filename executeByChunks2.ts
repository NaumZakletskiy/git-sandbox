export async function executeByChunks<T>(
    callbacks: (() => Promise<T>)[],
    chunkSize: number,
): Promise<void> {
    const chunks = [];
    for (let i = 0; i < callbacks.length; i += chunkSize) {
        chunks.push(callbacks.slice(i, i + chunkSize));
    }

    for (const chunk of chunks) {
        await Promise.all(chunk.map((callback) => callback()));
    }
}
